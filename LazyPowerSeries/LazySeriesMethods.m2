--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
--PowerSeriesFunctions (PowerSeriesFunctions.m2)

load "./HelperFunctions.m2";

LazySeries = new Type of HashTable;


net LazySeries := L -> (
    myStr := net("");
    local tempStr;
    local tempTerm;
    termList := reverse terms (L#cache#displayedPolynomial);
    j := 0;
    while (j < #termList) do (                
        tempStr = toString(termList#j);
        if (tempStr#0 === "-") then (
            tempTerm = (-1)*(termList#j);
            if (j > 0) then myStr = myStr | net(" - ");
            if (j == 0) then myStr = net("-");
        )
        else (
            if (j > 0) then myStr = myStr | net(" + ");
            tempTerm = termList#j;
        );
        myStr = myStr | net (tempTerm);                
        j = j+1;        
    );    
    net(myStr | net(" + ... "))
)

toString LazySeries := L -> (
    myStr := toString("");
    local tempStr;
    local tempTerm;
    termList := reverse terms (L#cache#displayedPolynomial);
    j := 0;
    while (j < #termList) do (                
        tempStr = toString(termList#j);
        if (tempStr#0 === "-") then (
            tempTerm = (-1)*(termList#j);
            if (j > 0) then myStr = myStr | toString(" - ");
            if (j == 0) then myStr = toString("-");
        )
        else (
            if (j > 0) then myStr = myStr | toString(" + ");
            tempTerm = termList#j;
        );
        myStr = myStr | toString (tempTerm);                
        j = j+1;        
    );    
    toString(myStr | toString(" + ... "))
)

lazySeries = method(Options => {Degree => 3, DisplayedDegree => 3, ComputedDegree => 3})

-- Making a LazySeries without the added computation of polynomial construction
lazySeries(Ring, Function, RingElement, RingElement) := opts -> (R, f, displayedPoly, computedPoly) -> (

    new LazySeries from {
        coefficientFunction => f,
        seriesRing => R,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly
        }
    }
)
-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
    --ringZeroes := numgens R:0;
    --ringZeroes := 0;
   
    local f;
    local s;
    deg := opts.DisplayedDegree; -- need to change it to computed degree actually because that should be priority for calculation
    if (class opts.DisplayedDegree === List) then deg = sum opts.DisplayedDegree;

    K:= calculatePolynomial(deg, R, function);
    s = K#0; -- polynomial
    f = K#1; -- function

     -- Making a new lazySeries
    L := new LazySeries from {
        --constantTerm => f sum degree (1_R),
        coefficientFunction => f,
        seriesRing => R,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => s,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => s
        } 
    };
    L 
);

-- Converting ring elements and polynomials into LazySeries
lazySeries(RingElement) := LazySeries => opts -> P -> ( 
    R := ring P; 
    f := v -> coefficient(v, P);

    deg:= sum (degree P); -- default degree
    if not (opts.DisplayedDegree === null) then deg = opts.DisplayedDegree;

    displayedPoly := part(0, deg, P);
      
    lazySeries(
        R,
        f,
        displayedPoly,
        P,
        DisplayedDegree => deg,
        ComputedDegree => deg
        ) 
);

lazySeries(LazySeries, Function) := LazySeries => opts -> (L, function) -> (    
    R := L#seriesRing;
    f := x -> sub(function x, R);

    s := 0;
    oldDeg := L.cache.DisplayedDegree;
    
     -- add terms to s up to deg degree.
    for i from 0 to oldDeg do (
        s = s + (f i)*L^i;
        );    
     -- Making a new lazySeries
    newDeg := s.cache.ComputedDegree;
    newFunction := s#coefficientFunction;

    lazySeries(
        R,
        newFunction,
        truncate(oldDeg, s.cache.displayedPolynomial),
        truncate(oldDeg, s.cache.computedPolynomial),
        DisplayedDegree => oldDeg,
        ComputedDegree=> newDeg
        )
);


--*******************************************************
--Methods that use LazySeries object and its constructors
--*******************************************************

-- Changing degree of LazySeries
changeDegree = method()
changeDegree(LazySeries, ZZ) := LazySeries => (L, newDeg) -> (

    oldDispDeg := L.cache.DisplayedDegree;
    oldCompDeg := L.cache.ComputedDegree;
    f := L#coefficientFunction;
    R := L#seriesRing;
    local tempPoly;

    if newDeg == oldDispDeg then (
        L
    )    
    else if newDeg > oldDispDeg then (
        if oldCompDeg >= newDeg then (--if we've already computed that high, just use it
            L.cache.DisplayedDegree = newDeg;
            tempPoly = truncate(newDeg, L.cache.computedPolynomial);
            L.cache.displayedPolynomial = tempPoly;
        )
        else ( --otherwise we have to compute everything
            L.cache.ComputedDegree = newDeg;
            L.cache.DisplayedDegree = newDeg;
            tempPoly = (calculatePolynomial(newDeg, R, f))#0;
            L.cache.computedPolynomial = tempPoly;
            L.cache.displayedPolynomial = tempPoly;
            --lazySeries(R, f, DisplayedDegree => newDeg, ComputedDegree => newDeg)
        );
    )
    else (
        L.cache.DisplayedDegree = newDeg;
        L.cache.displayedPolynomial = part(0, newDeg, L.cache.displayedPolynomial);
    );

    L
);
-- changes ComputedDegree and computedPolynomial only
changeComputedDegree = method()
changeComputedDegree(LazySeries, ZZ) := LazySeries => (L, newDeg) -> (

    oldDeg := L.cache.DisplayedDegree;
    oldPoly := L.cache.displayedPolynomial;

    f := L#coefficientFunction;
    R := L#seriesRing;
    local tempPoly;

    if (debugLevel > 0) then print "tried to change computed degree to a lower value, nothing done";

    if newDeg <= oldDeg then L
    else if newDeg > oldDeg then (
        
        L#cache#ComputedDegree = newDeg;
        tempPoly = (calculatePolynomial(newDeg, R, f))#0;
        L#cache#computedPolynomial = tempPoly;

        lazySeries(
            R,
            f,
            oldPoly,
            tempPoly,
            DisplayedDegree => oldDeg,
            ComputedDegree => newDeg)
    )
);

-- overloading coefficient method
coefficient(VisibleList, LazySeries) := (indexVector, L) ->(
    --need to recalculate computedPolynomial if maximumsList(indexVector) is higher than the highest monomial 
    -- need to do changeDegree(L, maximumsList()); 
    coefficientValues := {};

    f := 0;
    h := 0;
    local val;
    
    if (sum indexVector <= L#cache#ComputedDegree) then (
        val = coefficient(indexVector, L#cache#computedPolynomial);                
    )
    else if ( (L#cache)#?indexVector ) then (
        val = (L#cache)#indexVector;
    )
    else (
        val = (L#coefficientFunction)(indexVector);
        L#cache#indexVector = val;
    );
    val
    --checks cache of LazySeries first and grabs the coefficients if available
);
coefficient(VisibleList, RingElement) := (L, P) -> coefficient(toMonomial(L, ring P), P); -- USE THIS FOR RINGELEMENT TO LAZYSERIES CONSTRUCTOR
coefficient(ZZ, RingElement) := (n, P) -> coefficient(toMonomial({n}, ring P), P); -- for one 

coefficient(RingElement, LazySeries) := (M, L) ->(
    print ;
    -- check if monomial
    -- see existing coefficient function
);

--returns the ring of a LazySeries
ring(LazySeries) := L -> L#seriesRing;

-- Returns displayed polynomial
polynomial = method()
polynomial(LazySeries):= L -> L.cache.displayedPolynomial;

-- Get polynomial of a LazySeries of specified degree 
-*getPolynomial(LazySeries, List) := RingElement => (S, deg) -> (
    R := S#seriesRing;
    P := S.cache.displayedPolynomial;
    select(sub(P, R), i -> degree i >= deg)
);
*-

-- Get coefficient function of a LazySeries (THINKING OF REMOVING BECAUSE WE DON'T WANT USERS TO SEE)
getFunction = method()
getFunction(LazySeries) := Function => S -> (
    S#coefficientFunction
);


-- Overloading of sub; Promotes LazySeries defined over a ring to the specified new ring
sub(LazySeries, Ring) := LazySeries => (L, R) -> (
    f := getFunction(L);
    newDisplayedPoly := sub(L.cache.displayedPolynomial, R);
    newComputedPoly := sub(L.cache.computedPolynomial, R);

    lazySeries(
        R,
        f,
        newDisplayedPoly,
        newComputedPoly,
        DisplayedDegree => L.cache.DisplayedDegree,
        ComputedDegree => L.cache.ComputedDegree
        )
);

-- Overloading of isUnit method; checks if the leading coefficient is a unit in the ring
isUnit(LazySeries) := Boolean => L -> (
    constantTerm := part(0, L.cache.displayedPolynomial);
    isUnit(constantTerm)
    
);

-- Questionable....
-*
makeSeriesCompatible = method()
makeSeriesCompatible(LazySeries, LazySeries) := Sequence => (A,B) -> (
    if (A#seriesRing === B#seriesRing) == false then error "Rings of series do not match";
    -- might add sub to promote one of the series into the other ring ??????????????

    if A#DisplayedDegree == B#DisplayedDegree then (A,B)
    else if A#DisplayedDegree > B#DisplayedDegree then (changeDegree(A, B#DisplayedDegree), B)
    else (A, changeDegree(B, A#DisplayedDegree))
    );
*-