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
    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

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
    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

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

    try sub(n, R) -- CHECKS IF NUMBER MAKES SENSE IN THE SERIES RING, TRY
    else error("Cannot promote number to Series ring");

    if n == 1 then S;

    f := S#coefficientFunction;
    R := S#seriesRing;
    n = sub(n, R);

    if n == 0 then zeroSeries(R);

    

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
    if n == 1 then S;

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