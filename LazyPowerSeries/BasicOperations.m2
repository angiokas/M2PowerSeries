
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
        if (v == ringZeroes) then 1
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
    newDispDegree := min(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    newCompDegree := min(A.cache.ComputedDegree, B.cache.ComputedDegree);

    a := truncate(newDispDegree, A.cache.displayedPolynomial);
    b := truncate(newDispDegree, B.cache.displayedPolynomial);
    newDispPoly :=  a + b;
    a2 := truncate(newCompDegree, A.cache.computedPolynomial);
    b2 := truncate(newCompDegree, B.cache.computedPolynomial);
    newCompPoly := a2 + b2;
    

    lazySeries(
        A.seriesRing,
        newFunction,
        newDispPoly,
        newCompPoly,
        DisplayedDegree => newDispDegree,
        ComputedDegree => newCompDegree
        )
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match"; -- checks if using same ring

    f := A.coefficientFunction;
    g := B.coefficientFunction;
    R := A#seriesRing;

    newFunction:= v -> f v - g v;
    newDispDegree := min(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    newCompDegree := min(A.cache.ComputedDegree, B.cache.ComputedDegree);

    a := truncate(newDispDegree, A.cache.displayedPolynomial);
    b := truncate(newDispDegree, B.cache.displayedPolynomial);
    newDispPoly :=  a - b;
    a2 := truncate(newCompDegree, A.cache.computedPolynomial);
    b2 := truncate(newCompDegree, B.cache.computedPolynomial);
    newCompPoly := a2 - b2;
    

    lazySeries(
        A.seriesRing,
        newFunction,
        newDispPoly,
        newCompPoly,
        DisplayedDegree => newDispDegree,
        ComputedDegree => newCompDegree
        )
);

-- Adding and substracting scalars to LazySeries
Number + LazySeries := LazySeries => (n, L) -> (
    f := L#coefficientFunction;
    R := ring L;

    try sub(n, R) then n = sub(n, R)
    else error("Cannot promote number to Series ring");

    --ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring    
    if(n == 0) then L;

    newFunction := v -> (if all(v, t->t==0) then n + (f v)
                               else (f v)
                               );

    newPoly := n + L.cache.displayedPolynomial;
    newPolyComputed := n + L.cache.computedPolynomial;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPolyComputed,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
        )
);

LazySeries + Number := LazySeries => (L, n) -> n + L;

Number - LazySeries := LazySeries => (n, L) -> (
    R := ring L;
    f := L#coefficientFunction;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    
    --ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    if(n == 0) then L;

    newFunction:= v -> (
        if all(v, t->t==0) then n - (f v)
        else (- (f v))
        );
    
    newPoly := n - L.cache.displayedPolynomial;
    newComputedPoly := n - L.cache.computedPolynomial;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newComputedPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
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
    newPoly := n * (L.cache.displayedPolynomial);
    newComputedPoly := n * (L.cache.computedPolynomial);

    lazySeries(
        R,
        newFunction,
        newPoly,
        newComputedPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
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

    if (n == 0) then error "cannot divide by zero";

    if not isUnit(n) then error "argument to divide by is not a unit in this ring";
    oneOverN := sub(1/n, R);

    oneOverN * L
-*    
    newFunction:= v -> (f v) * oneOverN;
    newPoly := (calculatePolynomial((L.cache.DisplayedDegree), R, newFunction))#0;

    --newPoly := L.cache.displayedPolynomial / n;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.DisplayedDegree
        )
    *-
);

-*
LazySeries / RingElement := LazySeries => (S, P) -> (
    
    if n == 0 then error "Cannot divide by 0"; -- have to change 0 to ring 0

    f := S#coefficientFunction;
    R := S#seriesRing;
    try sub(P, R) then P = sub(P, R) 
    else error("Cannot promote number to Series ring");

    ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators 

    newFunction:= v -> (f v) / P; -- have to think about this
    --newPoly := L.displayedPolynomial / P;
    
    
    lazySeries(
        R,
        newFunction,
        newPoly,
        newPoly,
        DisplayedDegree => L.DisplayedDegree,
        ComputedDegree => L.DisplayedDegree
        )
);
*-
-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (L, n) -> (

    f := L#coefficientFunction;
    R := ring L;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");    

    if (n == 0) then error "cannot divide by zero";

    if not isUnit(n) then error "argument to divide by is not a unit in this ring";
        
    newFunction:= v-> (f v) // n;
    newPoly := L.cache.displayedPolynomial // n;
    newComputedPoly := L.cache.computedPolynomial // n;

    lazySeries(
        R,
        newFunction,
        newPoly,
        newComputedPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
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
    --newDegree := min(A.cache.DisplayedDegree + B.cache.DisplayedDegree, 10);

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

    changeDegree(finalSeries, newDegree)
    
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
        return inverse(S^(-n));
    );

    bin := toBinary(n);
    finalResult := 1;
    tempCalculation:= S;
    j := 1;

    while (true) do (     
        if(bin#(#bin-j) == 1) then (
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
    c = sub(c, coefficientRing (L#seriesRing));
    d := 1/c;

    g := ((-1)*((L * d)-1)); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    h := d * (lazySeries(g, i->1)); 

    changeDegree(h, L.cache.DisplayedDegree) -- degree must be the same to get 1 from multiplying later!!
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