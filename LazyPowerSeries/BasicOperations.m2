
------------------------------------------- BASIC OPERATIONS -----------------------------------------------------------

--*************************************************
--Basic operations outputting Power Series
--*************************************************
--===================================================================================

-- Zero series
zeroSeries = method(Options=>{DisplayedDegree => 3, ComputedDegree => 3}) -- maybe we can just change it to a variable instead??
zeroSeries(Ring) := LazySeries => opts -> R -> (
    f := i -> 0;
    P := sub(0, R);    
    lazySeries(R, f, P, P, DisplayedDegree=>opts.DisplayedDegree, ComputedDegree => opts.ComputedDegree)
);

-- One series
oneSeries = method(Options=>{DisplayedDegree => 3, ComputedDegree => 3})
oneSeries(Ring) := LazySeries => opts -> R -> (
    ringZeroes := (numgens R:0);
    if (numgens R == 1) then ringZeroes = 0;
    
    f := v -> (
        if (v == ringZeroes) then sub(1, R)
        else sub(0, R)
        );

    P := sub(1, R);

    lazySeries(R, f, P, P, DisplayedDegree=>opts.DisplayedDegree, ComputedDegree =>opts.ComputedDegree)
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

    a := truncate(newDispDegree, A.cache.displayedPolynomial); -- truncate TO PART

    b := truncate(newDispDegree, B.cache.displayedPolynomial); -- truncate TO PART
    newDispPoly :=  a + b;

    a2 := truncate(newCompDegree, A.cache.computedPolynomial); -- truncate TO PART
    b2 := truncate(newCompDegree, B.cache.computedPolynomial); -- truncate TO PART
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

    a := truncate(newDispDegree, A.cache.displayedPolynomial); -- truncate TO PART
    b := truncate(newDispDegree, B.cache.displayedPolynomial); -- truncate TO PART
    newDispPoly :=  a - b;
    a2 := truncate(newCompDegree, A.cache.computedPolynomial); -- truncate TO PART
    b2 := truncate(newCompDegree, B.cache.computedPolynomial); -- truncate TO PART
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
    if (debugLevel > 1) then print "multiplying lazy by integer";
    f := L.coefficientFunction;
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

- LazySeries := L -> (-1)*L;
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

    newDegree := min(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    a := truncate(newDegree, A.cache.displayedPolynomial);
    b := truncate(newDegree, B.cache.displayedPolynomial);
    newCompDegree := min(A.cache.ComputedDegree, B.cache.ComputedDegree);    

    newPoly := truncate(newDegree, a*b);
    newCompPoly := truncate(newCompDegree, (truncate(newCompDegree, A.cache.computedPolynomial))*(truncate(newCompDegree, B.cache.computedPolynomial)));

    myCache := new CacheTable from {computedPolynomial => newCompPoly, ComputedDegree => newCompDegree, displayedPolynomial => newPoly, DisplayedDegree => newPoly};  

    --myCache should be used as the new cache object, and use an internal-only constructor, or manually create the object

    newFunction := coefficientVector -> (
        tempDegree := coefficientVector;
        
        if instance(coefficientVector, List) or instance(coefficientVector, Sequence) then tempDegree = sum coefficientVector;

        if (myCache#ComputedDegree >= tempDegree) then return (coefficient(coefficientVector, myCache#computedPolynomial)); -- ???
                
        changeComputedDegree(A, tempDegree);
        changeComputedDegree(B, tempDegree);

        P1 := truncate(tempDegree, A.cache.computedPolynomial);
        P2 := truncate(tempDegree, B.cache.computedPolynomial);

        P := truncate(tempDegree, P1*P2);

        coefficient(coefficientVector, P)
    );

    --changeComputedDegree(A, newDegree);
    --changeComputedDegree(B, newDegree);
    
    finalSeries := lazySeries(
        R,
        newFunction,
        newPoly,
        newCompPoly,
        DisplayedDegree =>  newDegree,
        ComputedDegree => newCompDegree
        );

    newFastChangeDegree := i -> (
        changeComputedDegree(A, i);
        changeComputedDegree(B, i);
        P1 := truncate(i, A.cache.computedPolynomial);
        P2 := truncate(i, B.cache.computedPolynomial);
        myPoly := truncate(i, P1*P2);
        myPoly
    );

    (finalSeries.cache)#"FastChangeComputedDegree" = newFastChangeDegree;

    finalSeries
    --changeDegree(finalSeries, newDegree)    
);

-- Multiplication of LazySeries by RingElement

RingElement * LazySeries := LazySeries => (P, L) -> (
    --if (ring n === S#seriesRing) == false then error "Rings of series and number do not match"; -- checks if using same ring\
    if (debugLevel > 1) then print "Multiplying lazy by RingElement.";
    R := L#seriesRing;
    local P2;
    -- NEED TO ADD CONDITIONALS OF WHEN P is ring 1 or 0;
    try P2 = sub(P, R) then P2 = sub(P, R)
    else error("Cannot promote RingElement to LazySeries Ring"); -- coul try adding another condition for checking if we can promote series to ringElement ring
    print "making new ring";
    lazyP := lazySeries(P2, DisplayedDegree => L#cache#DisplayedDegree);
    print "still making new ring";
    lazyP * L 
);

LazySeries * RingElement := LazySeries => (S,x) -> x * S;

-- Raising LazySeries by nth power
LazySeries ^ ZZ := LazySeries => (S,n) -> (
    R := S#seriesRing;
    if n == 0 then return lazySeries(sub(1, R), DisplayedDegree=>S#cache#DisplayedDegree);--oneSeries(R);
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
    coeffRing := coefficientRing (L#seriesRing);
    if isUnit(L) == false then error "Cannot invert series because it is not a unit";
    c := truncate(0, L); --part(0, L.cache.displayedPolynomial);
    c = sub(c, coeffRing);
    d := sub(sub(1/c, coeffRing), L#seriesRing);    

    g := ((-1)*((L * d)-1)); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...    
    tempSeries := lazySeries(g, i->1);
    h := d * (tempSeries); 
    h#cache#"FastChangeComputedDegree" = i -> d*(tempSeries#cache#"FastChangeComputedDegree")(i);
    h
    --changeDegree(h, L.cache.DisplayedDegree) -- degree must be the same to get 1 from multiplying later!!
);

--Division of two LazySeries--
LazySeries / LazySeries := LazySeries => (A, B)->(
    A * inverse(B)
)
-- Dividing a number by LazySeries
Number / LazySeries := LazySeries => (n, B)->(
    n * inverse(B)
)

----------------------------------- Operations using polynomials and LazySeries-------------------------------

LazySeries + RingElement := LazySeries => (L,f) -> (
    M := lazySeries(f);
    L+M
)
RingElement + LazySeries := LazySeries => (f,L) -> (L+f)

LazySeries - RingElement := LazySeries => (L,f) -> (
    M := lazySeries(f);
    L - M
)
RingElement - LazySeries := LazySeries => (f,L) -> (
    M := lazySeries(f);
    M-L
)

LazySeries* RingElement := LazySeries => (L,f) -> (
    M := lazySeries(f);
    L*M
)
RingElement*LazySeries := LazySeries => (f,L) -> (L*f)

LazySeries / RingElement := LazySeries => (L,f) -> (
    M := lazySeries(f);
    L/M
)

RingElement /LazySeries := LazySeries => (L,f) -> (
    M := lazySeries(f);
    M/L
)
