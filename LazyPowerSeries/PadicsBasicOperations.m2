
--*************************************************
--Basic operations outputting PadicSeries
--*************************************************
--===================================================================================
-- The zero
zeroPadics = method(Options=>{DisplayedDegree => 5}) -- maybe we can just change it to a variable instead??
zeroPadics(ZZ, Ring) := PadicSeries => opts -> (p, R) -> (
    f := sub(0, R);    
    padics(p, f, DisplayedDegree=>opts.DisplayedDegree, ComputedDegree =>opts.DisplayedDegree)
);

-- The identity
onePadics = method(Options=>{DisplayedDegree => 5})
onePadics(Ring) := PadicSeries => opts -> (p, R) -> (
    ringZeroes := (((numgens R)+1):0);
    if (numgens R == 1) then ringZeroes = 0;
    
    f := v -> (
        if (v == ringZeroes) then sub(1, R)
        else sub(0, R)
        );

    padics(p, R, f, DisplayedDegree=> opts.DisplayedDegree, ComputedDegree => opts.DisplayedDegree)
);

-- ADDITION------------------------------------------------------------------
PadicSeries + PadicSeries := PadicSeries => (A, B) -> (
    if (A.seriesRing === B.seriesRing) == false then error "Rings of series do not match";
    if (A.primeNumber != B.primeNumber) then error "prime number of adic completion do not match";

    f := A.coefficientFunction;
    g := B.coefficientFunction;
    p := A.primeNumber;

    newFunction:= v -> f v + g v;

    newDispDegree := min(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    newCompDegree := min(A.cache.ComputedDegree, B.cache.ComputedDegree);

    a := truncate(newCompDegree, A.cache.computedPolynomial, Prime => p);
    b := truncate(newCompDegree, B.cache.computedPolynomial, Prime => p); 

    newCompPoly := a + b;

    padics(
        p,
        newFunction,
        newCompPoly,
        DisplayedDegree => newDispDegree,
        ComputedDegree => newCompDegree
        )

);

Number + PadicSeries := PadicSeries => (n, L) -> (
    f := L#coefficientFunction;
    R := ring L;
    p := L.primeNumber;

    try sub(n, R) then n = sub(n, R)
    else error("Cannot promote number to PadicSeries Series ring");

    --ringZeroes := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring    
    if(n == 0) then L;

    newFunction := v -> (if all(v, t->t==0) then n + (f v)
                               else (f v)
                               );

    newCompPoly := n + L.cache.computedPolynomial;

    padics(
        p,
        newFunction,
        newCompPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
        )
);

PadicSeries + Number := PadicSeries => (L, n) -> n + L;

----------------------------------- MULIPLICATION BY PADICS--------------------------------------------------------

Number * PadicSeries := PadicSeries => (n, L) -> (
    f := L.coefficientFunction;
    R := ring L;
    p := L.primeNumber;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to given Padic series ring");

    if n == 1 then L;
    if n == 0 then zeroPadics(R);

    newFunction:= v -> (n * (f v));
    newPoly := n * (L.cache.displayedPolynomial);
    newCompPoly := n * (L.cache.computedPolynomial);

    padics(
        p,
        newFunction,
        newCompPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
        )
);


PadicSeries * Number := PadicSeries => (L, n) -> n * L;

- PadicSeries := L -> (-1)*L;

PadicSeries - PadicSeries := PadicSeries => (A,B) -> (
    B = (-1)*B;
    A + B
);

PadicSeries - Number := PadicSeries => (L, n) -> L + (-n);
Number - PadicSeries := (n, L) -> (
    L = (-1)*L;
    n + L
);

LazySeries / Number := LazySeries => (L, n) -> (
    if n == 0 then error "Cannot divide by 0";
    if n == 1 then L;

    f := L#coefficientFunction;
    R := L#seriesRing;

    try sub(n, R) then n = sub(n, R) 
    else error("Cannot promote number to Series ring");

    if (n == sub(0,R)) then error "cannot divide by zero";

    if not isUnit(n) then error "argument to divide by is not a unit in this ring";
    oneOverN := sub(1/n, R);

    oneOverN * L
);

PadicSeries * PadicSeries := PadicSeries => (A,B)->(
    f := A.coefficientFunction;
    g := B.coefficientFunction;
    p := A.primeNumber;

    if (A.seriesRing === B.seriesRing) == false then error "Rings of series do not match";
    if (A.primeNumber != B.primeNumber) then error "prime number of adic completion do not match";

    newDispDegree := max(A.cache.DisplayedDegree, B.cache.DisplayedDegree);
    newCompDegree := max(A.cache.ComputedDegree, B.cache.ComputedDegree); 

    a := truncate(newCompDegree, A.cache.computedPolynomial, Prime => p);
    b := truncate(newCompDegree, B.cache.computedPolynomial, Prime => p); 

    newCompPoly := truncate( newCompDegree, a*b, Prime => p);

    newFunction := coefficientVector -> (
            deg := coefficientVector;
            if instance(coefficientVector, List) or instance(coefficientVector, Sequence) then deg = sum coefficientVector;

            if (newCompDegree >= deg) then return (coefficient(coefficientVector,newCompPoly));
                    
            --changeComputedDegree(A, tempDegree); !!!!!!!!!
            --changeComputedDegree(B, tempDegree);

            P1 := truncate( deg, A.cache.computedPolynomial, Prime=> p);
            P2 := truncate( deg, B.cache.computedPolynomial, Prime => p);

            P := truncate(deg, P1*P2, Prime => p);

            coefficient(coefficientVector, P)
        );

    finalSeries:= padics(
        p,
        newFunction,
        newCompPoly,
        DisplayedDegree => newCompDegree,
        ComputedDegree => newDispDegree
        );

        -- Add a fast change degree function to it
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

);
-- Raising LazySeries by nth power
PadicSeries ^ ZZ := PadicSeries => (S,n) -> (
    R := S.seriesRing;
    p := S.primeNumber;
    if n == 0 then return onePadics(p, R);
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
------

inverse(PadicSeries) := PadicSeries => (L) -> (
    -- first check if it is a unit in the ring
    R := L.seriesRing;
    p := L.primeNumber;
    if isUnit(L) == false then error "Cannot invert Padic series because it is not a unit";

    c := L.cache.valueList#(sub(1,R));
    c = sub(c, ZZ);
    d := lift (c_(ZZ/p)^-1, ZZ);    

    g := ((-1)*((L * d)-1)); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...    
    tempSeries := padics(g, i->1);
    h := d * (tempSeries); 
    --h#cache#"FastChangeComputedDegree" = i -> d*(tempSeries#cache#"FastChangeComputedDegree")(i);
    h
    --changeDegree(h, L.cache.DisplayedDegree) -- degree must be the same to get 1 from multiplying later!!
);
PadicSeries / PadicSeries:= PadicSeries => (f,g) -> (
    f*(g^-1)

);

----------------------------------- Operations using polynomials and PadicSeries-------------------------------
PadicSeries + RingElement := PadicSeries => (L,f) -> (
    p := L.primeNumber;
    M := padics(p, f);
    L+M
)
RingElement + LazySeries := PadicSeries => (f,L) -> (L+f)

PadicSeries - RingElement := PadicSeries => (L,f) -> (
    p := L.primeNumber;
    M := padics(p, f);
    L - M
)
RingElement - PadicSeries := PadicSeries => (f,L) -> (
    p := L.primeNumber;
    M := padics(p, f);
    M-L
)

PadicSeries* RingElement := PadicSeries => (L,f) -> (
    p := L.primeNumber;
    M := padics(p, f);
    L*M
)
RingElement*PadicSeries := PadicSeries => (f,L) -> (L*f)

PadicSeries / RingElement := PadicSeries => (L,f) -> (
    p := L.primeNumber;
    M := padics(p, f);
    L/M
)

RingElement /PadicSeries := PadicSeries => (L,f) -> (
    p := L.primeNumber;
    M := padics(p, f);
    M/L
)