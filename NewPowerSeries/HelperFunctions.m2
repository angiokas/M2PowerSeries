
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