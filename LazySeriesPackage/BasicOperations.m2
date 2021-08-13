
------------------------------------------- BASIC OPERATIONS -----------------------------------------------------------
--*************************************************
--Basic operations outputting Power Series
--*************************************************
--===================================================================================

-- Zero series
zeroSeries = method() -- maybe we can just change it to a variable instead??
zeroSeries(Ring) := LazySeries => R -> (
    f := variables -> 0;
    P := sub(0, R);

    lazySeries(R, f, P, P)
    );

-- One series
oneSeries = method()
oneSeries(Ring) := LazySeries => R -> (
    ringZeroes := (numgens R:0);
    if (numgens R == 1) then ringZeroes = 0;
    
    f := v -> (
        if (v == ringZeroes) or (v == {ringZeroes}) then 1
        else 0
        );

    P := sub(1, R);

    lazySeries(R, f, P, P)
    );
------------------------ BASIC OPERATIONS----------------------------------------------------------

--Addition and substraction of two LazySeries
LazySeries + LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring

    f := A.coefficientFunction;
    g := B.coefficientFunction;
    R := A#seriesRing;

    newFunction:= v -> f v + g v;
    newDegree := min(A.cache.DisplayedDegree, B.cache.DisplayedDegree);

    a := parts(0, newDegree, A.cache.displayedPolynomial);
    b := parts(0, newDegree, B.cache.displayedPolynomial);
    newPoly :=  a + b;

    lazySeries(
        A.seriesRing,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => newDegree,
        ComputedDegree => newDegree
        )
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring
    f := A.cache.coefficientFunction;
    g := B.cache.coefficientFunction;
    R := A#seriesRing;

    newFunction:= v-> f v - g v;
    newDegree := max(A.cache.DisplayedDegree, B.cache.DisplayedDegree);

    a := parts(0, newDegree, A.cache.displayedPolynomial);
    b := parts(0, newDegree, B.cache.displayedPolynomial);
    newPoly :=  a - b;

    -- Do we want similar calculatiion for ComputedDegree? Do we want long ComputedDegree calculations?

    lazySeries(
        A.seriesRing,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => newDegree,
        ComputedDegree => newDegree
        )
);

-- Adding and substracting scalars to LazySeries
Number + LazySeries := LazySeries => (n, L) -> (
    f := L#coefficientFunction;
    R := ring L;

    try sub(n, R) then n = sub(n, R)
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring
    
    if(n == 0) then L;

    newFunction := v -> (if v == ringZeroes then n + (f v)
                               else (f v)
                               );

    newPoly := n + L.displayedPolynomial;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
);

LazySeries + Number := LazySeries => (L, n) -> n + L;

Number - LazySeries := LazySeries => (n, L) -> (
    R := ring L;
    f := L#coefficientFunction;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    
    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    if(n == 0) then L;

    newFunction:= v -> (
        if v == ringZeroes then n - (f v)
        else (- (f v))
        );
    
    newPoly := n - L.displayedPolynomial;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
);

LazySeries - Number := LazySeries => (L, n) -> L + (-n);

-- Multilplying LazySeries by a scalar
Number * LazySeries := LazySeries => (n, L) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    f := L#coefficientFunction;
    R := ring L;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    if n == 1 then L;
    if n == 0 then zeroSeries(R);

    --newComputedPoly := n * (S#computedPolynomial);

    newFunction:= v -> (n * (f v));
    newPoly := n * (L#displayedPolynomial);

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )

);

LazySeries * Number := LazySeries => (L, n) -> n * L;

-- Exact division by scalar (the `/` binary operator)
LazySeries / Number := LazySeries => (L, n) -> (
    if n == 0 then error "Cannot divide by 0";
    if n == 1 then L;

    f := L#coefficientFunction;
    R := L#seriesRing;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 

    newFunction:= v -> (f v) / n;
    newPoly := L.displayedPolynomial / n;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
    
);
-* NEED TO FIX
LazySeries / RingElement := LazySeries => (S, P) -> (
    
    if n == 0 then error "Cannot divide by 0"; -- have to change 0 to ring 0

    f := S#coefficientFunction;
    R := S#seriesRing;
    try sub(P, R) then P = sub(P, R) 
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 

    newFunction:= v -> (f v) / P; -- have to think about this
    newPoly := L.displayedPolynomial / P;
    
    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
);*-

-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (L, n) -> (

    f := L#coefficientFunction;
    R := ring L;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 
    

    newFunction:= v-> (f v) // n;
    newPoly := L.displayedPolynomial // n;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
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
    
    newFunction := coefficientVector -> (
        
        tempDegree := coefficientVector; -- bandaid!!!!!

        if(class coefficientVector === List) then tempDegree = sum coefficientVector;
        

        a := changeComputedDegree(A, tempDegree);
        b := changeComputedDegree(B, tempDegree);

        P1 := a.cache.computedPolynomial;
        P2 := b.cache.computedPolynomial;

        P := truncate(newDegree, P1*P2);

        coefficient(coefficientVector, P)
        
    );

    changeComputedDegree(A, newDegree);
    changeComputedDegree(B, newDegree);
    newPoly := truncate(newDegree, (truncate(newDegree, A.cache.computedPolynomial))*(truncate(newDegree, B.cache.computedPolynomial)));

    finalSeries := lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree =>  newDegree,
        ComputedDegree => newDegree);
    changeDegree(finalSeries, max(A.cache.DisplayedDegree, B.cache.DisplayedDegree))
    
);

-- Multiplication of LazySeries by RingElement

RingElement * LazySeries := LazySeries => (P, L) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    R := L#seriesRing;
    -- NEED TO ADD CONDITIONALS OF WHEN P is ring 1 or 0;
    try P = sub(P, R) then P = sub(P, R)
    else error("Cannot promote RingElement to LazySeries Ring"); -- coul try adding another condition for checking if we can promote series to ringElement ring
    
    lazyP := lazySeries(P);
      
    lazyP * L
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

inverse(LazySeries) := LazySeries => (L) -> (
    -- first check if it is a unit in the ring
    if isUnit(L) == false then error "Cannot invert series because it is not a unit";
    c := part(0, L.cache.displayedPolynomial);

    print ((-1)*((L / c)-1));
    g := ((-1)*((L / c)-1)); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    print "THIS IS g: ";
    print g;
    print "CALCULATING MACLAURIN SERIES";
    print c;
    print "lazy";
    print (lazySeries(g, i->1));
    h := (1/c) * lazySeries(g, i->1); -- temporary displayDegree
    print "CALCULATED";
    changeDegree(L.cache.DisplayedDegree, h)
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
