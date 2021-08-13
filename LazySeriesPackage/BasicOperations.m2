
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
    
    f := variables -> (
        if (variables == ringZeroes) or (variables == {ringZeroes}) then 1
        else 0
        );

    P := sub(1, R);

    lazySeries(R, f, P, P)
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
