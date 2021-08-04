--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
Series = new Type of HashTable

--===================================================================================
-- CONSTRUCTING SERIES
series = method(Options => {Degree => 2})
export{
--PowerSeriesFunctions (PowerSeriesFunctions.m2)
    "maxDegree",
    "polynomial",
    "lazySeries"

}
export{"coefficientFunction", "termVariables", "constantTerm",
       "variables", "displayedPolynomial","seriesRing", "listPolynomial",
       "toBinary", "zeroSeries", "oneSeries",
       "tempCalculations", "seriesCalculation", "binDigit","maclaurinSeries", "displayedDegree", "computedDegree" }

-- Helper functions
export{"toLazySeries",
       "changeDegree",
       "makeSeriesCompatible",
       "getCoefficient",
       "getPolynomial",
       "getFunction"}


LazySeries = new Type of HashTable
lazySeries = method(Options => {Degree => 2, displayedDegree => 3, computedDegree => 3})
--LAZY SERIES

-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
    f := (x) -> sub(function (x), R);

    ringVariables := gens R;
    
    try f (numgens R:0) then 1 -- checks to see if f was inputted correctly by plugging in (0 0 ... 0)
    else error "Number of inputs of given function does not match number of ring generators";

    combinations := {};
    for j from 0 to opts.displayedDegree do
        combinations = append(combinations, compositions (#ringVariables,j)); 
    combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left

    s := 0;
     -- add opts.Degree terms to s.
    for j from 0 to #combinations-1 do 
        s = s + (f toSequence(combinations#j)) * product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));-- ADDED SUB HERE
    if debugLevel >2 then print s;
     -- Making a new lazySeries
    new LazySeries from {
        displayedDegree => opts.displayedDegree,
        computedDegree => opts.computedDegree,
        constantTerm => f (numgens R:0),
        maxDegree => infinity,
        displayedPolynomial => s,
        coefficientFunction => f,
        -- getCoefficient => coefficientVector-> f (toSequence coefficientVector),
        termVariables => ringVariables,
        seriesRing => R,
        cache => new CacheTable from {} -- for calculating powers!!!!!! IMPLEMENTTT
    }
);

------------------------------------------- HELPER FUNCTIONS -----------------------------------------------------------

-- Converting ring elements and polynomials into LazySeries
toLazySeries = method()
toLazySeries(RingElement) := LazySeries => P -> (-- Isn't outputting correct degree for the polynomial
    listPolynomial := listForm P;
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
    lazySeries(R, h)
)

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
    else lazySeries(R, f, displayedDegree => newDeg, computedDegree => oldDeg)
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
    if debugLevel > 3 then print S#coefficientFunction;
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

getCoefficient(LazySeries, Sequence) := LazySeries =>  (S,coefficientVector) -> (
    if debugLevel > 3 then print S#coefficientFunction;
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

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
    variables := vars(1..(numgens R)); -- why am I not using gens R????????????????????????!!!!
    newFunction:= variables-> f variables + g variables;
    newDegree := max(A#displayedDegree, B#displayedDegree);

    changeDegree(lazySeries(R, newFunction), newDegree)
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := vars(1..(numgens R));
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
    variables := vars(1..(numgens R));

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
    variables := vars(1..(numgens R));

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

    variables := vars(1..(numgens R));

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
    
    variables := vars(1..(numgens R));

    newFunction:= variables-> (f variables) / n;
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
    
    variables := vars(1..(numgens R));

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

    newFunction := coefficientVector -> (
        s := 0;
        L := toList ringZeroes .. toList coefficientVector;
        for i from 0 to #L-1 do
            s = s + ((f toSequence(L#i)) * g toSequence(toList coefficientVector -  (L#i)));    
        s
    );
    lazySeries(R, newFunction, displayedDegree => A#displayedDegree + B#displayedDegree, computedDegree => A#displayedDegree + B#displayedDegree) -- REMOVED DISPLAYED DEGREE FOR A BIT
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
);

tempInverse = method()
tempInverse(LazySeries) := LazySeries => S ->(
    f := S#coefficientFunction;
    R := S#seriesRing;

);

-- inserting the `S` from `1/(S-x)`

maclaurinSeries = method() -- bad method
maclaurinSeries(LazySeries, ZZ):= LazySeries => (S, deg) ->(
    finalResult := 0;
    for i from 0 to deg do (
        finalResult = finalResult + S^i;
    );
    finalResult
);

lazySeries(LazySeries, Function) := LazySeries => opts -> (S, function) -> (
    f := (x) -> sub(function (x), R);
    R := S#seriesRing;

    s:=0;
     -- add opts.Degree terms to s.
    for i from 0 to S#displayedDegree do (
        s = s + (f i)*S^i;
        print s#displayedPolynomial;
        );
    
    if debugLevel >2 then print s;
     -- Making a new lazySeries
    new LazySeries from {
        displayedDegree => opts.displayedDegree,
        computedDegree => opts.computedDegree,
        constantTerm => s#constantTerm,
        maxDegree => infinity,
        displayedPolynomial => s,
        coefficientFunction => f,
        -- getCoefficient => coefficientVector-> f (toSequence coefficientVector),
        termVariables => S,
        seriesRing => R,
        cache => new CacheTable from {
            
        } -- for calculating powers!!!!!! IMPLEMENTTT
    }
);

inverse(LazySeries) := LazySeries => (S) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    print "STARTING INVERSE";
    g := (-1)*((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    print "CALCULATING MACLAURIN SERIES";
    h := (1/S#constantTerm) * lazySeries(g, i->1);
    print "CALCULATED";
    h
);

inverse(LazySeries, ZZ) := LazySeries => (S, deg) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1) * ((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (1/S#constantTerm) * maclaurinSeries (g, deg)
    
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
)

expression Series := s -> pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"

--===================================================================================
