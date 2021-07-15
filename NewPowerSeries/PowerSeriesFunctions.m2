--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
Series = new Type of HashTable

--===================================================================================
-- CONSTRUCTING SERIES
series = method(Options => {Degree => 5})

export{"setPrecision", "coefficientFunction", "getCoefficient", "termVariables", "constantTerm",
       "variables", "displayedPolynomial","seriesRing","formalTaylorSeries",
       "toBinary", "zeroSeries", "oneSeries",
       "tempCalculations", "seriesCalculation", "binDigit", "newCalculation","maclaurinSeries"}

LazySeries = new Type of HashTable
lazySeries = method(Options => {Degree => 2})
--LAZY SERIES

-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
  
    ringVariables := gens R;
    
    try function (numgens R:0) then 1 -- checks to see if function was inputted correctly by plugging in (0 0 ... 0)
    else error "Number of inputs of given function does not match number of ring generators";

    combinations := {};
    for j from 0 to opts.Degree do
        combinations = append(combinations, compositions (#ringVariables,j)); 
    combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left

    s :=0;
     -- add opts.Degree terms to s.
    for j from 0 to #combinations-1 do 
        s = s+ (function toSequence(combinations#j))* product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));
    print s;
     -- Making a new lazySeries
     new LazySeries from {
        displayedDegree => opts.Degree,
        computedDegree => opts.Degree,
        constantTerm => function (numgens R:0),
        maxDegree => infinity,
        displayedPolynomial => s,
        coefficientFunction => function,
        getCoefficient => coefficientVector-> function (toSequence coefficientVector),
        termVariables => ringVariables,
        seriesRing => R
    }
);

-- Zero series
zeroSeries = method()
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
-- Getting coefficient value

getCoefficient = method()
getCoefficient(LazySeries, List) := LazySeries =>  (S,coefficientVector) -> (
    print S#coefficientFunction;
    print S#coefficientFunction toSequence coefficientVector;
);


--Addition and substraction of two LazySeries
LazySeries + LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := vars(1..(numgens R));
    newFunction:= variables-> f variables + g variables;
    lazySeries(R, newFunction)
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := vars(1..(numgens R));
    newFunction:= variables-> f variables - g variables;
    lazySeries(R, newFunction)
);

-- Multiplication of two LazySeries
LazySeries * LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
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
    lazySeries(R, newFunction)
);

-- Converting to binary
toBinary = method()
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
    if n == 2 then return S*S;

    finalResult := oneSeries(R); -- prints this one
    bin := toBinary(n);
    tempCalculations := {S};
    binDigit := 0;
    seriesCalculation := 0;

    for i from 0 to #bin-1 when i>=0 do(
        binDigit = bin#(#bin-1-i);
        seriesCalculation = tempCalculations#i;

        if (binDigit == 1) then finalResult = finalResult * seriesCalculation;

        tempCalculations = append(tempCalculations, seriesCalculation * seriesCalculation);
    );
    print "FINAL RESULT:";
    finalResult
);

-- Adding and substracting scalars to LazySeries
Number + LazySeries := LazySeries => (n,S) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    variables := vars(1..(numgens R));

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n + (f variables)
                               else (f variables));
    lazySeries(R, newFunction)
);

LazySeries + Number := LazySeries => (S,n) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    if(n == 0) then lazySeries(R, variables -> 0);

    newFunction:= variables-> (if variables == ringZeroes then (f variables) + n
                               else (f variables));
    lazySeries(R, newFunction)
);

Number - LazySeries := LazySeries => (n,S) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    variables := vars(1..(numgens R));

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZeroes then n - (f variables)
                               else (f variables)) ;
    lazySeries(R, newFunction)
);

LazySeries - Number := LazySeries => (S,n) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    if(n == 0) then lazySeries(R, variables -> 0);

    newFunction:= variables-> (if variables == ringZeroes then (f variables) - n
                               else (f variables))  ;
    lazySeries(R, newFunction)
);
-- Multilplying LazySeries by a scalar
Number * LazySeries := LazySeries => (n,S) -> (
    f := S#coefficientFunction;
    R := S#seriesRing;

    if(n == 0_R) then lazySeries(R, variables -> 0);

    variables := vars(1..(numgens R));

    newFunction:= variables-> (n * (f variables));
    lazySeries(R, newFunction)
);

LazySeries * Number := LazySeries => (S,n) -> (
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0;
    
    variables := vars(1..(numgens R)); -- Could replace with termVariables from the constructor??

    if(n == 0_R) then lazySeries(R, variables -> 0); -- 0_R is the zero of the ring

    newFunction:= variables-> ((f variables) * n);
    lazySeries(R, newFunction)
);
-- Exact division by scalar (the `/` binary operator)
LazySeries / Number := LazySeries => (S,n) -> (
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    newFunction:= variables-> (f variables) / n;
    lazySeries(R, newFunction)
);
-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (S,n) -> (
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    newFunction:= variables-> (f variables) // n;
    lazySeries(R, newFunction)
);

-- INVERSION

isUnit(LazySeries) := Boolean => S -> (
    isUnit(S#constantTerm)
);
-- inserting the `S` from `1/(S-x)`
maclaurinSeries = method()
maclaurinSeries(LazySeries,ZZ):= LazySeries => (S, deg) ->(
    finalResult := 0;
    for i from 0 to deg do (
        finalResult = finalResult + S^i;
    );
    finalResult
);
inverse(LazySeries) := LazySeries => (S) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1)*((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (1/S#constantTerm) * maclaurinSeries (g, 5)
    
);
inverse(LazySeries,ZZ) := LazySeries => (S, deg) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1)*((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (1/S#constantTerm) * maclaurinSeries (g, deg)
    
);
-- Division of two LazySeries
LazySeries / LazySeries := LazySeries => (A,B)->(
    A* inverse(B)
)















--===================================================================================    
-- Displays the series in a more organized way
pretty Series := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#displayedDegree+2,
                i -> part_i(truncate(s#displayedDegree, s#polynomial))
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e,Sum) then
        new Parenthesize from {e} 
        else e
)

expression Series := s -> pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#degree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"

--===================================================================================
