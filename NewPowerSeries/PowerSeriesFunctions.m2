--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
--PowerSeriesFunctions (PowerSeriesFunctions.m2)

load "./HelperFunctions.m2";

LazySeries = new Type of MutableHashTable;

net LazySeries := L -> (
    myStr := net("");
    local tempStr;
    local tempTerm;
    termList := reverse terms (L#cache#displayedPolynomial);
    j := 0;
    while (j < #termList) do (                
        tempStr = toString(termList#j);
        if (tempStr#0 === "-") then (
            tempTerm = (-1)*(termList#j);
            if (j > 0) then myStr = myStr | net(" - ");
            if (j == 0) then myStr = net("-");
        )
        else (
            if (j > 0) then myStr = myStr | net(" + ");
            tempTerm = termList#j;
        );
        myStr = myStr | net (tempTerm);                
        j = j+1;        
    );    
    net(myStr | net(" + ... "))
)

toString LazySeries := L -> (
    myStr := toString("");
    local tempStr;
    local tempTerm;
    termList := reverse terms (L#cache#displayedPolynomial);
    j := 0;
    while (j < #termList) do (                
        tempStr = toString(termList#j);
        if (tempStr#0 === "-") then (
            tempTerm = (-1)*(termList#j);
            if (j > 0) then myStr = myStr | toString(" - ");
            if (j == 0) then myStr = toString("-");
        )
        else (
            if (j > 0) then myStr = myStr | toString(" + ");
            tempTerm = termList#j;
        );
        myStr = myStr | toString (tempTerm);                
        j = j+1;        
    );    
    toString(myStr | toString(" + ... "))
)

lazySeries = method(Options => {Degree => 3, DisplayedDegree => 3, ComputedDegree => 3, coefficientFunction => null})

-- Making a LazySeries without the added computation of polynomial construction
lazySeries(Ring, Function, RingElement, RingElement) := opts -> (R, f, displayedPoly, computedPoly) -> (

    new LazySeries from {
        coefficientFunction => f,
        seriesRing => R,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly
        }
    }
)
-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
    --try f ringZeroes then 1 -- checks to see if f was inputted correctly by plugging in (0 0 ... 0)
    --else error "Number of inputs of given function does not match number of ring generators";
    -- ^ I think this check is a bit useless since the problem could be something else besides the number of inputs
    --ringZeroes := numgens R:0;
    --ringZeroes := 0;
   
    local f;
    local s;
    deg := opts.DisplayedDegree; -- need to change it to computed degree actually because that should be priority for calculation
    if (class opts.DisplayedDegree === List) then deg = sum opts.DisplayedDegree;

    K:= calculatePolynomial(deg, R, function);
    s = K#0;
    f = K#1;

     -- Making a new lazySeries
    L := new LazySeries from {
        --constantTerm => f sum degree (1_R),
        coefficientFunction => f,
        seriesRing => R,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => s,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => s
        } -- store powers as well
    };
    --print (L#cache)#displayedPolynomial;
    L 
);

-- Converting ring elements and polynomials into LazySeries
lazySeries(RingElement) := LazySeries => opts -> P -> ( 
    R := ring P;
    variables := gens R;
    local newFunction;
    if (opts.coefficientFunction === null) then (
        newFunction = variables -> coefficient(variables, P)
    )
    else(
        newFunction = opts.coefficientFunction;
    );
    deg:= sum (degree P); -- default degree
    if not (opts.DisplayedDegree === null) then deg = opts.DisplayedDegree;

    displayedPoly := part(0, deg, P);
      
    lazySeries(R, newFunction, displayedPoly, P, DisplayedDegree => deg, ComputedDegree => deg) 
);


lazySeries(LazySeries, Function) := LazySeries => opts -> (S, function) -> (    
    R := S#seriesRing;
    f := x -> sub(function x, R);

    s:=0;
     -- add opts.Degree terms to s.
    for i from 0 to S#DisplayedDegree do (
        s = s + (f i)*S^i;
        );    
     -- Making a new lazySeries
    new LazySeries from {
        
        constantTerm => s#constantTerm,
        coefficientFunction => s#coefficientFunction,
        seriesRing => R,

        cache => new CacheTable from {
            DisplayedDegree => s.DisplayedDegree,
            ComputedDegree => s.ComputedDegree,
            displayedPolynomial => s#displayedPolynomial,
            computedPolynomial => s#displayedPolynomial

        } -- for calculating powers!!!!!! IMPLEMENTTT
    }
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changing degree of LazySeries
changeDegree = method()
changeDegree(LazySeries, ZZ) := LazySeries => (S, newDeg) -> (

    oldDeg := S.cache.DisplayedDegree;
    f := S#coefficientFunction;
    R := S#seriesRing;
    local tempPoly;

    if newDeg == oldDeg then S
    else if newDeg > oldDeg then (
        S#cache#ComputedDegree = newDeg;
        S#cache#DisplayedDegree = newDeg;
        tempPoly = (calculatePolynomial(newDeg, R, f))#0;
        S#cache#computedPolynomial = tempPoly;
        S#cache#displayedPolynomial = tempPoly;
        --lazySeries(R, f, DisplayedDegree => newDeg, ComputedDegree => newDeg)
    )
    else (
        S#cache#DisplayedDegree = newDeg;
        S#cache#displayedPolynomial = truncate(newDeg, S#cache#displayedPolynomial);
    );
    S
);

changeComputedDegree = method()
changeComputedDegree(LazySeries, ZZ) := LazySeries => (S, newDeg) -> (

    oldDeg := S.cache.DisplayedDegree;
    f := S#coefficientFunction;
    R := S#seriesRing;
    local tempPoly;

    if newDeg == oldDeg then S
    else if newDeg > oldDeg then (
        S#cache#ComputedDegree = newDeg;
        tempPoly = (calculatePolynomial(newDeg, R, f))#0;
        S#cache#computedPolynomial = tempPoly;
        --lazySeries(R, f, DisplayedDegree => newDeg, ComputedDegree => newDeg)
    );
    S
);

-- overloading coefficient method
coefficient(VisibleList, LazySeries) := (indexVector, L) ->(
    --need to recalculate computedPolynomial if maximumsList(indexVector) is higher than the highest monomial 
    -- need to do changeDegree(L, maximumsList()); 
    coefficientValues := {};

    f := 0;
    h := 0;
    local val;
    
    if (sum indexVector <= L#cache#ComputedDegree) then (
        val = coefficient(indexVector, L#cache#computedPolynomial);                
    )
    else if ( (L#cache)#?indexVector ) then (
        val = (L#cache)#indexVector;
    )
    else (
        val = (L#coefficientFunction)(indexVector);
        L#cache#indexVector = val;
    );
    val
    --checks cache of LazySeries first and grabs the coefficients if available
);
coefficient(VisibleList, RingElement) := (L, P) -> coefficient(toMonomial(L, ring P), P); -- USE THIS FOR RINGELEMENT TO LAZYSERIES CONSTRUCTOR
coefficient(ZZ, RingElement) := (n, P) -> coefficient(toMonomial({n}, ring P), P); -- for one 

coefficient(RingElement, LazySeries) := (M, L) ->(
    print ;
    -- check if monomial
    -- see existing coefficient function
);

--returns the ring of a LazySeries
ring(LazySeries) := L -> L#seriesRing;

-- Returns displayed polynomial
getPolynomial = method()
getPolynomial(LazySeries):= L -> L.cache.displayedPolynomial;

-- Get polynomial of a LazySeries of specified degree 
getPolynomial(LazySeries, List) := RingElement => (S, deg) -> (
    R := S#seriesRing;
    P := S.cache.displayedPolynomial;
    select(sub(P, R), i -> degree i >= deg)
);

-- 
makeSeriesCompatible = method()
makeSeriesCompatible(LazySeries, LazySeries) := Sequence => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match";
    -- might add sub to promote one of the series into the other ring ??????????????

    if A#DisplayedDegree == B#DisplayedDegree then (A,B)
    else if A#DisplayedDegree > B#DisplayedDegree then (changeDegree(A, B#DisplayedDegree), B)
    else (A, changeDegree(B, A#DisplayedDegree))
    );


-- Get coefficient function of a LazySeries (THINKING OF REMOVING BECAUSE WE DON'T WANT USERS TO SEE)
getFunction = method()
getFunction(LazySeries) := Function => S -> (
    R := S#seriesRing;
    sub(S#coefficientFunction, R) --might want to change how i save functions inside the constructor instead of using sub here i.e use sub in the constructor
);


-- Overloading of sub; Promotes LazySeries defined over a ring to the specified new ring
sub(LazySeries, Ring) := LazySeries => (S,R) -> (
    f := getFunction(S);
    lazySeries(R, f, DisplayedDegree => S#DisplayedDegree, ComputedDegree => S#ComputedDegree)
);

-- Overloading of isUnit method; checks if the leading coefficient is a unit in the ring
isUnit(LazySeries) := Boolean => S -> (
    R := S#seriesRing;
    -- coefficientRing L; -- not sure if I even need this, since it promote it to the ring regardless
    isUnit(sub(S#constantTerm,R))
);

------------------------------------------- BASIC OPERATIONS -----------------------------------------------------------
--*************************************************
--Basic operations outputting Power Series
--*************************************************
--===================================================================================

-- Zero series
zeroSeries = method() -- maybe we can just change it to a variable instead??
zeroSeries(Ring) := LazySeries => R -> (
    variables := gens R;
    lazySeries(R, variables -> 0)
    );

-- One series
oneSeries = method()
oneSeries(Ring) := LazySeries => R -> (
    ringZeroes := (numgens R:0);
    variables := gens R;
    newFunction := variables -> (if variables == ringZeroes then 1
                                else 0
                                );
    lazySeries(R, newFunction)
    );
------------------------ BASIC OPERATIONS----------------------------------------------------------

--Addition and substraction of two LazySeries
LazySeries + LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring

    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := gens R; -- why am I not using gens R????????????????????????!!!!
    newFunction:= variables-> f variables + g variables;
    newDegree := max(A.cache.DisplayedDegree, B.cache.DisplayedDegree);

    changeDegree(lazySeries(R, newFunction), newDegree)
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := gens R;
    newFunction:= variables-> f variables - g variables;
    newDegree := max(A.cache.DisplayedDegree, B.cache.DisplayedDegree);

    changeDegree(lazySeries(R, newFunction), newDegree)
);

-- Adding and substracting scalars to LazySeries
Number + LazySeries := LazySeries => (n, S) -> (
    f := S#coefficientFunction;
    R := ring S;
    n = sub(n, R);
    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring
    variables := gens R;

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n + (f variables)
                               else (f variables));
    lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);

LazySeries + Number := LazySeries => (S,n) -> n+S;

Number - LazySeries := LazySeries => (n,S) -> (
    R := ring S;
    f := S#coefficientFunction;

    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

    
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring
    variables := gens R;

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n - (f variables)
                               else (f variables)) ;
    lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);

LazySeries - Number := LazySeries => (S,n) -> n-S;

-- Multilplying LazySeries by a scalar
Number * LazySeries := LazySeries => (n,S) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    f := S#coefficientFunction;
    R := ring S;
    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

    if n == 1 then S;
    if n == 0 then zeroSeries(R);

    variables := gens R;
    newComputedPoly := n*(S#computedPolynomial);

    newFunction:= variables-> (n * (f variables));

    --fix this so it doesn't compute things
    new LazySeries from {
        seriesRing => R,
        coefficientFunction => newFunction, 
        DisplayedDegree => S#DisplayedDegree;
        ComputedDegree => S#ComputedDegree;
        computedPolynomial => newComputedPoly;
        displayedPolynomial => truncate(S#DisplayedDegree, newComputedPoly);
    }

    --lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);

LazySeries * Number := LazySeries => (S,n) -> n * S;

-- Exact division by scalar (the `/` binary operator)
LazySeries / Number := LazySeries => (S,n) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring
    if n == 0 then error "Cannot divide by 0";
    if n == 1 then S;

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := gens R;

    newFunction:= variables-> (f variables) / n;
    lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);

LazySeries / RingElement := LazySeries => (S,x) -> (
    if (ring x === S#seriesRing) == false then error "Rings of series and ringElement do not match"; -- checks if using same ring
    if x == 0 then error "Cannot divide by 0"; -- have to change 0 to ring 0

    f := S#coefficientFunction;
    R := S#seriesRing;
    x = sub(x, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    variables := gens R;

    newFunction:= variables-> (f variables) / x;
    lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);

-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (S, n) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := ring S;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := gens R;

    newFunction:= variables-> (f variables) // n;
    lazySeries(R, newFunction, DisplayedDegree => S.cache.DisplayedDegree, ComputedDegree => S.cache.ComputedDegree)
);
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Multiplication of two LazySeries
LazySeries * LazySeries := LazySeries => (A,B) -> (
    if not (A#seriesRing === B#seriesRing) then error "Rings of series do not match"; -- checks if using same ring

    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    ringZeroes := numgens R:0;

    newDegree := max(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    print ("newDegree: " | toString(newDegree));
    
    newFunction := coefficientVector -> (
        print coefficientVector;
        tempDegree := coefficientVector; -- bandaid!!!!!
        if(class coefficientVector === List) then tempDegree = sum coefficientVector;
        print tempDegree;

        a := changeComputedDegree(A, tempDegree);
        
        b := changeComputedDegree(B, tempDegree);

        P1 := a.cache.computedPolynomial;
        P2 := b.cache.computedPolynomial;

        P := truncate(newDegree, P1*P2);
        --P = P1*P2;

        << "FINALRESULT: "<< coefficient(coefficientVector, P)<<endl;
        coefficient(coefficientVector, P)
        
    );    
    changeComputedDegree(A, newDegree);
    changeComputedDegree(B, newDegree);
    newPoly := truncate(newDegree, (truncate(newDegree, A.cache.computedPolynomial))*(truncate(newDegree, B.cache.computedPolynomial)));

    finalSeries := lazySeries(newPoly, coefficientFunction => newFunction, DisplayedDegree =>  newDegree, ComputedDegree => newDegree);
    changeDegree(finalSeries, max(A.cache.DisplayedDegree, B.cache.DisplayedDegree))
    --lazySeries(R, newFunction, DisplayedDegree =>  newDegree, ComputedDegree => newDegree)
);

-- Multiplication of LazySeries by RingElement

RingElement * LazySeries := LazySeries => (x,S) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    R := S#seriesRing;
    -- NEED TO ADD CONDITIONALS OF WHEN P is ring 1 or 0;
    try x = sub(x, R) then 1
    else error("Cannot promote RingElement to LazySeries Ring"); -- coul try adding another condition for checking if we can promote series to ringElement ring
    
    P := lazySeries(x);
      
    P*S
);

LazySeries * RingElement := LazySeries => (S,x) -> x * S;



-- Raising LazySeries by nth power
LazySeries ^ ZZ := LazySeries => (S,n) -> (
    R := S#seriesRing;
    if n == 0 then return oneSeries(R);
    if n == 1 then  return S;

    if n < 0 then (
        return inverse(S ^ (-n));
    );

    bin := toBinary(n);
    finalResult := 1;
    tempCalculation:= S;
    j := 1;
    while (true) do (     
        if(bin#(#bin-j)== 1) then (
            finalResult = tempCalculation;
            break;
        );        
        tempCalculation = tempCalculation * tempCalculation;
        j = j+1;
    );

    for i from 0 to #bin-j-1 when i >= 0 do(
        tempCalculation = tempCalculation * tempCalculation; 

        if bin#(#bin-j-1-i) == 1 then (
            finalResult = finalResult * tempCalculation;
        );       
    );
    finalResult

);
------------------------------------
tempInverse = method()
tempInverse(LazySeries) := LazySeries => S ->(
    f := S#coefficientFunction;
    R := S#seriesRing;

);

inverse(LazySeries) := LazySeries => (S) -> (
    -- first check if it is a unit in the ring
    if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    c := S#constantTerm;
    print "STARTING INVERSE";

    print ((-1)*((S / c)-1));
    g := ((-1)*((S / c)-1)); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    print "THIS IS g: ";
    print g;
    print "CALCULATING MACLAURIN SERIES";
    print c;
    print "lazy";
    print (lazySeries(g, i->1));
    h := (1/c) * lazySeries(g, i->1); -- temporary displayDegree
    print "CALCULATED";
    h
);
-*
inverse(LazySeries, ZZ) := LazySeries => (S, deg) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1) * ((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (S#constantTerm) * maclaurinSeries (g, deg)
    
);
*-
-- Division of two LazySeries
LazySeries / LazySeries := LazySeries => (A, B)->(
    A * inverse(B)
)
-- Dividing a number by LazySeries
Number / LazySeries := LazySeries => (n, B)->(
    n * inverse(B)
)


--===================================================================================    

-- Displays the series in a more organized way
-*pretty LazySeries := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#DisplayedDegree+2,
                i -> part_i(select(s#displayedPolynomial, i -> degree i >= {s#DisplayedDegree})) -- NEEDS TO BE FIXED BECAUSE DEGREE IN GRADED RINGS IS A LIST NOT AN INTEGER
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e, Sum) then
        new Parenthesize from {e} 
        else e
);

expression Series := s -> pretty s + expression "O(" expression(s#DisplayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#DisplayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#DisplayedDegree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#DisplayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#DisplayedDegree+1) expression ")"
*-
--===================================================================================