-- Truncates given polynomial
truncat = method()

truncat(InfiniteNumber, RingElement) := (n , P) ->(
     if n == infinity then return P;
     if n == -infinity then return sub(0, ring P);
     P
    );

truncat(ZZ, RingElement) := (n, p) ->(
    part(0,n,p)
    );

--toMonomial is a function that takes an exponent vector in the form of a list L and a polynomial ring S.
toMonomial = (L, S) -> (
     variableList := flatten entries vars S;
     m := 1;
     for i from 0 to (#L-1) do(
     	  m = m*(variableList)_i^(L#i);
     	  );
     m
);

-- Returns an n-tuple with maximum element from each index fromlist of n-tuples
maximumsList = method() -- WORKS
maximumsList(VisibleList) := l -> (-- ASSUMES THAT THE LIST PROVIDED HAS ELEMEMNTS OF THE SAME LENGTH i.e {{a,b},{c,d},{l,m}} where #{a,b}==#{c,d}==#{l,m}==2
    elementLength := #(l#0);
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
toBinary(ZZ) := n ->(
    b := {};
    num := floor(log(2, n)); -- Had to use this because n in the for loop settings won't change
    for i from 0 to num do(
        b = append(b,(n % 2));
        n = (n//2);
    );
    reverse b
);

calculatePolynomial = method()
calculatePolynomial(ZZ, Ring, Function) := (deg, R, function) ->(

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
        
        try sub(function dummyConstantVector, R) else (
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
            error "The lazySeries function should take a exponent vector and output a ring element";
        );
        try(
            if instance(newFunction(dummyConstantVector), R) then f = newFunction
            else f = v -> sub(newFunction v, R);
        ) else (
            error "The lazySeries function needs to output something that can be interpretted as a ring element.";
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

--Carrying = method()

calculatePartialSeries = method()
--deg is the degree of the partial series, R is the ring in which we are working in, f is the function that spits out coefficients
-- goal is for it to output parital series outputting function 
calculatePartialSeries(ZZ, Ring, Function) := (deg, R, f) ->(  
    --polynomial := calculatePolynomial(deg, R,f);

    g := i -> sum(apply(i, t-> ((f t)^t)))


);