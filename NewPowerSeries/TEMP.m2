--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================

--===================================================================================
-- CONSTRUCTING SERIES

export{
--PowerSeriesFunctions (PowerSeriesFunctions.m2)
    "displayedDegree", 
    "computedDegree",
    "maxDegree",
    "polynomial",
    "lazySeries"
}
export{"coefficientFunction",
       "constantTerm",
       "variables", 
       "displayedPolynomial",
       "seriesRing",
       "listPolynomial",
       "toBinary", 
       "zeroSeries", 
       "oneSeries",
       "tempCalculations", 
       "seriesCalculation", 
       "binDigit",
       "maclaurinSeries"
       }

-- Helper functions
export{"changeDegree",
       "makeSeriesCompatible",
       "getCoefficient",
       "getPolynomial",
       "getFunction"}


-*SemiMutableHashTable = new Type of HashTable{
    mutable => {}
    immutable => {}
}

*-

-- Converting ring elements and polynomials into LazySeries
lazySeries(RingElement) := LazySeries => opts -> P -> (-- Isn't outputting correct degree for the polynomial
    listPolynomial := listForm P; -- USES EXTRA MEMORY AND COMPUTING ITME
    R := ring P;
    variables := gens R;
    if debugLevel > 1 then print variables;

    h := variables ->(
    for i from 0 to #listPolynomial-1 do(
        
        if variables == (toSequence(listPolynomial#i)#0) then (
            if debugLevel > 1 then print variables;
            if debugLevel > 1 then print toSequence(listPolynomial#i)#0;
            if debugLevel > 1 then print "SUCCESS";
            return (listPolynomial#i)#1;
            )
        );
        0
    );
    lazySeries(R, h, displayedDegree => sum (degree P), computedDegree => sum (degree P)) -- temporary fix, but will have to make list degrees work in general
);

lazySeries(LazySeries, Function) := LazySeries => opts -> (S, function) -> (    
    R := S#seriesRing;
    f := x -> sub(function x, R);

    s:=0;
     -- add opts.Degree terms to s.
    for i from 0 to S#displayedDegree do (
        s = s + (f i)*S^i;
        if debugLevel >2 then print s#displayedPolynomial;
        );
    
    if debugLevel >2 then print s;
     -- Making a new lazySeries
    new LazySeries from {
        displayedDegree => s.displayedDegree,
        computedDegree => s.computedDegree,
        constantTerm => s#constantTerm,
        maxDegree => infinity,
        displayedPolynomial => s#displayedPolynomial,
        coefficientFunction => s#coefficientFunction,
        -- getCoefficient => coefficientVector-> f (toSequence coefficientVector),
        seriesRing => R,
        cache => new CacheTable from {

        } -- for calculating powers!!!!!! IMPLEMENTTT
    }
);

------------------------------------------- HELPER FUNCTIONS -----------------------------------------------------------
-*
toMonomial = (L,S) ->(-- CREDITS to: Jessica Sidman -- ADD THIS LATER WITH THE MYFUN FUNCTION
     variableList := flatten entries vars S;
     m := 1;
     for i from 0 to (#L-1) do(
     	  m = m*(variableList)_i^(L#i);
     	  );
     m
)


*-
--myFun = L -> coefficient(toMonomial(L, ring f), f) -- USE THIS FOR RINGELEMENT TO LAZYSERIES CONSTRUCTOR

-- Changing degree of LazySeries
changeDegree = method()
changeDegree(LazySeries, ZZ) := LazySeries => (S,newDeg) -> (
    oldDeg := S#displayedDegree;
    f := S#coefficientFunction;
    R := S#seriesRing;

    if newDeg == oldDeg then S
    else if newDeg > oldDeg then (
        lazySeries(R, f, displayedDegree => newDeg, computedDegree => newDeg)
        )
    else lazySeries(R, f, displayedDegree => newDeg, computedDegree => oldDeg) -- needs to truncate the displauedPolynomial too
);

-- 
makeSeriesCompatible = method()
makeSeriesCompatible(LazySeries, LazySeries) := Sequence => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match";
    -- might add sub to promote one of the series into the other ring ??????????????

    if A#displayedDegree == B#displayedDegree then (A,B)
    else if A#displayedDegree > B#displayedDegree then (changeDegree(A, B#displayedDegree), B)
    else (A, changeDegree(B, A#displayedDegree))
    );

-- Get coefficient value based on index
getCoefficient = method()
getCoefficient(LazySeries, List) := LazySeries =>  (S,coefficientVector) -> (
    
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

getCoefficient(LazySeries, Sequence) := LazySeries =>  (S,coefficientVector) -> (
    
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

-- overloading coefficient method
coefficient(Sequence, LazySeries) := (c,L) ->{
    --checks cache of LazySeries first and grabs the coefficients if available
    -- else change the computed degree up to the level we need and compute the polynomial up to the same level
    -- change computedDegree 
}
coefficient(Sequence, RingElement) := (c, P) ->( -- use Jessica's function
)
coefficient(RingElement, LazySeries) := (M, L) ->(
    -- check if monomial
    -- see existing coefficient function

)
-- Get polynomial of LazySeries
getPolynomial = method()
getPolynomial(LazySeries) := RingElement => S -> (
    R := S#seriesRing;
    P := S#displayedPolynomial;
    sub(P, R)
);

-- Get polynomial of a LazySeries of specified degree 
getPolynomial(LazySeries, List) := RingElement => (S, deg) -> (
    R := S#seriesRing;
    P := S#displayedPolynomial;
    select(sub(P, R), i -> degree i >= deg)
);

-- Get coefficient function of a LazySeries
getFunction = method()
getFunction(LazySeries) := Function => S -> (
    R := S#seriesRing;
    sub(S#coefficientFunction, R) --might want to change how i save functions inside the constructor instead of using sub here i.e use sub in the constructor
);


-- Overloading of sub; Promotes LazySeries defined over a ring to the specified new ring
sub(LazySeries, Ring) := LazySeries => (S,R) -> (
    f := getFunction(S);
    lazySeries(R, f, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

-- Overloading of isUnit method; checks if the leading coefficient is a unit in the ring
isUnit(LazySeries) := Boolean => S -> (
    R := S#seriesRing;
    -- coefficientRing L; -- not sure if I even need this, since it promote it to the ring regardless
    isUnit(sub(S#constantTerm,R))
);

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
    newDegree := max(A#displayedDegree, B#displayedDegree);

    changeDegree(lazySeries(R, newFunction), newDegree)
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := gens R;
    newFunction:= variables-> f variables - g variables;
    newDegree := max(A#displayedDegree, B#displayedDegree);

    changeDegree(lazySeries(R, newFunction), newDegree)
);


-- Adding and substracting scalars to LazySeries
Number + LazySeries := LazySeries => (n, S) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring
    variables := gens R;

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n + (f variables)
                               else (f variables));
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

LazySeries + Number := LazySeries => (S,n) -> n+S;

Number - LazySeries := LazySeries => (n,S) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring
    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring
    variables := gens R;

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n - (f variables)
                               else (f variables)) ;
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

LazySeries - Number := LazySeries => (S,n) -> n-S;

-- Multilplying LazySeries by a scalar
Number * LazySeries := LazySeries => (n,S) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    if n == 1 then S;

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);
    --try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    --else error("sjkfhaksdfhks");

    if(n == 0) then zeroSeries(R); 

    variables := gens R;

    newFunction:= variables-> (n * (f variables));
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

LazySeries * Number := LazySeries => (S,n) -> n * S;

-- Exact division by scalar (the `/` binary operator)
LazySeries / Number := LazySeries => (S,n) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := gens R;

    newFunction:= variables-> (f variables) / n;
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
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
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (S,n) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := gens R;

    newFunction:= variables-> (f variables) // n;
    lazySeries(R, newFunction, displayedDegree => S#displayedDegree, computedDegree => S#computedDegree)
);

-- Multiplication of two LazySeries
LazySeries * LazySeries := LazySeries => (A,B) -> (
    if not (A#seriesRing === B#seriesRing) then error "Rings of series do not match"; -- checks if using same ring

    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    ringZeroes := numgens R:0;

    -*
    newFunction := coefficientVector -> (
        s := 0;
        L := toList ringZeroes .. toList coefficientVector;
        for i from 0 to #L-1 do
            s = s + ((f toSequence(L#i)) * g toSequence(toList coefficientVector -  (L#i)));    
        s
    );
    *-

    newFunction := coefficientVector -> (
        tempDegree := sum coefficientVector;
        a := changeDegree(A, tempDegree);
        b := changeDegree(B, tempDegree);

        P1 := a#displayedPolynomial;
        P2 := b#displayedPolynomial;

        P = P1*P2;

        -- grab coefficient vector of P

    );

    newDegree := min(A#displayedDegree, B#displayedDegree);

    lazySeries(R, newFunction, displayedDegree =>  newDegree, computedDegree => newDegree) -- REMOVED DISPLAYED DEGREE FOR A BIT
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

-- Raising LazySeries by nth power
LazySeries ^ ZZ := LazySeries => (S,n) -> (
    R := S#seriesRing;
    if n == 0 then return oneSeries(R);
    if n == 1 then  return S;

    bin := toBinary(n);
    finalResult := 1;
    tempCalculation:= S;
    j := 1;
    while (true) do (
        -- print j;        
        if(bin#(#bin-j)== 1) then (
            finalResult = tempCalculation;
            break;
        );        
        tempCalculation = tempCalculation * tempCalculation;
        -- print "1 CALCULATION z";
        j = j+1;
    );
    -- << "final j: "<< j <<endl;

    for i from 0 to #bin-j-1 when i >= 0 do(
        -- << "#bin-j-1-i: " << #bin-j-1-i<< endl;
        tempCalculation = tempCalculation * tempCalculation; 
        -- print "1 CALCULATION y";
        if bin#(#bin-j-1-i) == 1 then (
            finalResult = finalResult * tempCalculation;
            -- print "1 CALCULATION x";
        );       
    );
    finalResult
    -- NEED TO ADD OPTION FOR NEGATIVE POWERS AS WELL!!!!!!!!!!!!
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

inverse(LazySeries, ZZ) := LazySeries => (S, deg) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1) * ((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (S#constantTerm) * maclaurinSeries (g, deg)
    
);
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
pretty LazySeries := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#displayedDegree+2,
                i -> part_i(select(s#displayedPolynomial, i -> degree i >= {s#displayedDegree})) -- NEEDS TO BE FIXED BECAUSE DEGREE IN GRADED RINGS IS A LIST NOT AN INTEGER
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e, Sum) then
        new Parenthesize from {e} 
        else e
);

expression Series := s -> pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"

--===================================================================================
