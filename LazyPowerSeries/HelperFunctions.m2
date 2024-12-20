-- Truncates given polynomial

truncate(InfiniteNumber, RingElement) := {Prime => 0} >> opts -> (n, f) ->(
     if n == infinity then return f;
     if n == -infinity then return sub(0, ring f);
     f
    );

truncate(ZZ, RingElement) := {Prime => 0} >> opts -> (n, f) -> (
    if (# (gens ring f) == 0 ) then (
        return f;
    )
    else if (opts.Prime == 0) then (        
        --rewrite this to make it better (12/17/2024 - Karl)
        -- OLD code     
        if #degree(sub(1, ring f)) == 1 then return part(0,n,f);  --singly graded case
        --now the multigraded case
        wtList := apply(#gens ring f, j -> 1);
        return part(0,n,wtList, f);
    )
    else (
        R := ring f;
        p := opts.Prime;
        I := sub(ideal(gens R | {p}), R);
        dispPoly := f % I^(n+1);
        dispPoly
    )
);


truncate(ZZ, ZZ) := {Prime => 0} >> opts -> (n, f) -> (
    if(opts.Prime == 0) then f
    else (
        R := ZZ;
        p := opts.Prime;
        I := sub(ideal(p), R);
        displayedPoly := f % I^(n+1);
        displayedPoly
    )
    
);

--toMonomial is a function that takes an exponent vector in the form of a list L and a polynomial ring S. Returns 
toMonomial = method()
toMonomial(List, Ring) := RingElement => (L, S) -> ( -- ??????????
     variableList := flatten entries vars S;
     m := 1;
     for i from 0 to (#L-1) do(
     	  m = m*(variableList)_i^(L#i);
     	  );
     m
);

-- Returns an n-tuple with maximum element from each index from a list of n-tuples
maximumsList = method() -- WORKS
maximumsList(VisibleList) := List => l -> (-- ASSUMES THAT THE 
    
    try elementLength := #(l#0)
    else error("LIST PROVIDED HAS ELEMEMNTS OF THE SAME LENGTH i.e {{a,b},{c,d},{l,m}} where #{a,b}==#{c,d}==#{l,m}==2");
    maximums := {};
    maximumValue := 0;
    for j from 0 to (elementLength-1) do(
        maximumValue = max(apply(l, i-> i#j));
        maximums = append(maximums,maximumValue );
    );

    maximums
);

-- Converting to binary
toBinary = method() -- GENERALIZE TO BASE P
toBinary(ZZ) := List => n ->(
    b := {};
    num := floor(log(2, n)); -- Had to use this because n in the for loop settings won't change
    for i from 0 to num do(
        b = append(b,(n % 2));
        n = (n//2);
    );
    reverse b
);

-*
toModp = method()
toModp(ZZ, p) := ZZ => n,p-> (
    R := ring ZZ/p;
    lift(sub(n, R),ZZ)
);
*-

-- Constructs a polynomial using the given ring and constructive function that has the proper amount of arguments corresponding to the dimension of the ring
calculatePolynomial = method()
calculatePolynomial(ZZ, Ring, Function) := RingElement => (deg, R, function) ->(

    combinations := {};
    start := 0;
    
    ringVariables := gens R;

    s := sub(0, R);
    local f;
    local newFunction;
    newFunction = function;

    -*if (numgens R == 1) then ( -- 1-variable version
        f = x -> sub(function x, R);
        --ringZeroes = 0;

        for i from 0 to deg do s = s + (f i)*(ringVariables#0)^i;
        )*-
    --else 
    
     -- n>1 n-variable version
    dummyConstantVector := apply(numgens R, t -> 0);        
        
    try sub(function dummyConstantVector, R)
    else (
            try sub(function toSequence dummyConstantVector, R) then (
                --print "first thing worked";
                newFunction = tempList -> function toSequence tempList
            )
            else(                
                --print "second thing worked";
                --print (function (dummyConstantVector#0));
                newFunction = tempList -> function (tempList#0); 
            );
    );
        
    try newFunction dummyConstantVector --then ( print (newFunction dummyConstantVector) )
    else (
            error "The lazySeries function should take a exponent vector and output a ringElement.";
         );
    
    try(
            if instance(newFunction(dummyConstantVector), R) then f = newFunction
            else f = v -> sub(newFunction v, R);
        )
    else(
            error "The lazySeries function needs to output something that can be interpretted as a ringElement.";
        );
        
    for j from start to deg do (-- IT WONT WORK WITH MULTI GRADED RINGS WITH DEGREES THAT ARE LISTS, can use `from ringZeroes .. to opts.displayedPolynomial`, but it gives error somewhere else down the line
            --print compositions (#ringVariables, j);
            combinations = append(combinations, compositions (#ringVariables, j)); 
        );

        combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left
        
     -- add ops.Degree terms to s.
    for j from 0 to #combinations-1 do (
        s = s + (f (combinations#j)) * product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));
        );
    
    s
);


calculatePartialSeries = method()

-- goal is for it to output parital series outputting function. Outputs a polynomial.
calculatePartialSeries(ZZ, Ring, Function) := RingElement => (deg, R, f) ->(  --deg is the degree of the partial series, R is the ring in which we are working in, f is the function that spits out coefficients
    --polynomial := calculatePolynomial(deg, R,f);

    g := i -> sum(apply(i, t-> ((f t)^t)))

);

-- Converts a negative number to a positive representation in mod p. Ex: converts -1 in mod 7 to ((-1 % 7) + 7) % 7 =6
toPositiveRep =  method()
toPositiveRep(ZZ,ZZ) := ZZ => (p,n) -> (
    ((n % p) + p) % p
    );

-- Extracts information about the appropariate coefficients of a polynomial in p-adics form
toAdics = method(Options=>{PositiveCoefficients=>false})
toAdics(ZZ, Thing) := List => opts -> (p, poly) -> (
    R := ring poly;
    local deg;

    try workingf := sub(poly,R)
    else error("Cannot interpret the second argument as a ring element.");

    coefficientslist := {};
    if(workingf == 0) then deg = -1
    else if (instance (workingf, RingElement)) then deg = ceiling(log_p leadCoefficient workingf) + (sum degree workingf)
    else deg= ceiling(log_p workingf);

    m := (ideal p)+(ideal gens R); -- Ex. p = 7 and R = ZZ[x,y,z] then (7)+(x,y,z) = (7,x,y,z)

    local workingIdeal;
    local workingList;
    local workingIdeal2;
    local currentMonomial;
    local n;

    local workingf2;
    local workingCoefficient;
    local tempMonomial; 
    local j;

    outputList := {}; 


    for i from 0 to deg do(
        workingIdeal =sub( m^(i+1), R);
        workingList = first entries gens (m^i); -- list of generators of the ideal m^i for ex. m^2 = (49,7x,x^2) then working_list is {49,7x,x^2}
        n = #workingList;

        if debugLevel > 1 then (
            print ("i = "| toString(i));
            print ("workingIdeal: " | toString(workingIdeal));
            print("workingList: " | toString(workingList));
        );
        j = 0;
        while (j < n) and not(workingf == 0) do(
--        for j from 0 to n-1 do(
            currentMonomial = sub(workingList#0, R);
            workingList = drop(workingList,{0,0});
            workingIdeal2 = trim(ideal(workingList) + workingIdeal);-- ex. trim(ideal (x)+ideal(49,7*x, x^2)) = trim(ideal(x,49,7*x, x^2))= ideal(49, x)

            workingf2 = workingf % workingIdeal2;  
            try tempMonomial = sub((entries((coefficients(currentMonomial))#0))#0#0, R)
            else tempMonomial = sub(currentMonomial, R); --in case it is ZZ, BANDAID

            try workingCoefficient = coefficient(tempMonomial, workingf2)/ coefficient(tempMonomial, currentMonomial)
            else workingCoefficient = workingf2 / currentMonomial;

            if  opts.PositiveCoefficients and (workingCoefficient < 0) then
            (   
                workingCoefficient = workingCoefficient+p;
                workingf2 = workingf2+p*currentMonomial;
            );

            outputList = append(outputList, currentMonomial => sub(workingCoefficient,ZZ)); -- Was returning class QQ without this
            workingf = workingf - workingf2;
            

            if debugLevel > 1 then (
                print ("j = "| toString(j));
                print("workingf: " | toString(workingf));
                print ("currentMonomial: "| toString(currentMonomial));
                print ("workingList: " | toString(workingList));
                print ("workingIdeal2: " |toString(workingIdeal2));
                print ("workingf2: " | toString(workingf2));
                print ("tempMonomial: " | toString(tempMonomial));
                print ("WorkingCoefficient: " | toString(workingCoefficient));
            );
            j = j+1;
        );
    ); 
    hashTable (sort(outputList))
);


-- Constructs polynomials using functions intended for calculating p-adics coefficients
constructAdicsPoly = method(Options => { Degree => 3})
    constructAdicsPoly(Ring, ZZ, Function) := RingElement => opts -> (R, p, f) -> ( 
    -- the function should be describing the coefficients in terms of i_0, i_1,...,i_n where i_0 corresponds to p as a variable
    if (not isPrime(p)) then error( toString(p) | " is not prime.");

    variables := {sub(p, R)} | toList gens R;
    combinations := {};
    start := 0;
    s := sub(0, R);

    newFunction:= inputFunctionCheck(R, variables, f);
    ------
    for j from start to opts.Degree do (
                combinations = append(combinations, compositions (#variables, j)); 
            );
        combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left       
        
    for j from 0 to #combinations-1 do (
        s = s + (newFunction (combinations#j)) * product(apply(#variables, i -> (variables#i)^((combinations#j)#i)));
        );   
    s
);

constructAdicsPoly(List) := PadicSeries => L -> (
    termList :=(apply(L, i-> i#0));
    coefficientList :=(apply(L, i-> i#1));

    s := 0;

    for j from 0 to #termList-1 do (
        s = s + (coefficientList#j * termList#j);
    );
    s
);

constructAdicsPoly(ZZ, HashTable) := PadicSeries => (d, H) -> (
    termList :=(apply(H, i-> i#0));
    coefficientList :=(apply(H, i-> i#1));
    deg:= 

    s := 0;

    for j from 0 to deg do (
        s = s + (coefficientList#j * termList#j);
    );
    s
);

--------------------
-- Outputs a slightly altered function to accomodate proper input or spits out an error in case of wrong intended argument number
inputFunctionCheck = method() 
inputFunctionCheck(Ring, VisibleList, Function) := Function => (R, variables, f) -> (

    dummyConstantVector := apply(#variables, t -> 0);

    newFunction := f;
    local newf;

    try sub(f dummyConstantVector, R)
        else (
                try sub(f toSequence dummyConstantVector, R) then (

                    newFunction = tempList -> (f toSequence tempList)
                )
                else(                

                    newFunction = tempList -> f (tempList#0); 
                );
        );
            
    try newFunction dummyConstantVector --then ( print (newFunction dummyConstantVector) )
    else (
            error "The lazySeries function should take a exponent vector and output a ringElement.";
        );
    
    try(
            if instance(newFunction(dummyConstantVector), R) then newf = newFunction
            else newf = v -> sub(newFunction v, R);
        )
    else(
            error "The lazySeries function needs to output something that can be interpretted as a ringElement.";
        );
    newf

);
