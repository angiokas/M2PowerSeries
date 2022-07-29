--*******************************************************
--Implementation of P-ADICS
--*******************************************************


padicOrder = method() -- Works with ZZ elements and RingElements of polynomial rings
padicOrder(ZZ, Thing) := ZZ => (p, f) ->(
    if (f==0) then return -infinity;
    p = sub(p,ring f);
    i := 0;
    tempf := sub(0,ring f);
    while(tempf == 0) do (
        i = i+1;
        tempf = f % ideal (p^i);
    );
    return i-1;

);



PadicSeries = new Type of HashTable; -- Could potentially change it to HashTable since so far have not used inheritence

toString PadicSeries := L -> (
    myStr := net("");

    local tempStr;
    local k;
    local tempTerm;
    local stringList; 

    p := L.primeNumber;

    --valueList := pairs L.cache.valueList; -- turns the hashtable into a list of pairs (key, value) and then sortrs by key
    myRing := L.seriesRing;
    varList := first entries vars myRing;
    degToDisp := L.cache.DisplayedDegree;
    exponentList := reverse sort compositions(2+#varList, degToDisp);
    extendedVarList := {sub(1, myRing), sub(p, myRing)} | varList;
    valueList := apply(exponentList, myExp -> (tempKey := product(apply(#myExp, i -> (extendedVarList#i)^(myExp#i) ));  (myExp, tempKey, if (L.cache.valueList)#?tempKey then (L.cache.valueList)#tempKey else sub(0, myRing) )));
    
    scan(valueList, (expKey, key, val)->(
        if(val != 0) then (
            k = expKey#1;

            try tempTerm = toString((entries monomials(key))#0#0)
                else tempTerm = "";
            if(tempTerm == "1" ) then tempTerm = "";

            if (val < 0) then val = " - " | toString(abs(val))
            else val = " + " | toString(val);

            if (k == 0) then (
                if (tempTerm != "") then tempStr = val | "*" | tempTerm
                else tempStr = toString(val)
            )
            else if(k == 1) then (
                tempStr = val | "*" | toString(p) | tempTerm
                )
            else if(k > 1) then (
                tempStr = val | "*" |toString(p) | "^" | toString(k) | tempTerm;
                );
            myStr = myStr | tempStr
            );
        
        )
    );
    myStr = toString(myStr);
    if (#myStr != 0 and myStr#1 == "+") then myStr = substring(3, myStr);
    toString(myStr | toString(" + ... "))

); 

net PadicSeries := L -> (net(toString L));

----------------------PADICS CONSTRUCTORS-----------------------------------------------------------------

padics = method(Options => { Degree => infinity, DisplayedDegree => 5, ComputedDegree => 5, PositiveCoefficients=>false})

-- Constructs PadicSeries over the given ring R using inputted coefficient function f 
padics(ZZ, Ring, Function) := PadicSeries => opts -> (p, R, f) -> (

    computedPoly := constructAdicsPoly(R, p, f,  Degree => opts.ComputedDegree);
    tempValueList := toAdics(p, computedPoly, PositiveCoefficients=>opts.PositiveCoefficients);
    displayedPoly := sub(0, R); -- Truncating could be different since users might want to treat degree with variables p, x_1,...,x_n

    currentDegree := 0;
    maxIdeal := ideal({p} | gens R);

    while(currentDegree < opts.DisplayedDegree) do (
        currentDegree = currentDegree + 1;
        displayedPoly = displayedPoly + sum(apply(first entries gens (maxIdeal^currentDegree),j-> j*(tempValueList#j)))        
    );

    new PadicSeries from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            Degree => infinity,
            valueList => tempValueList
        }
    }
);

--converts polynomials to PadicSeries
padics(ZZ, RingElement) := PadicSeries => opts -> (p, g) -> ( 
    R := ring g; 
    f := v -> coefficient(v, g);

    --deg:= infinity; -- default degree, it should be infinite unless the user says
    --if not (opts.DisplayedDegree === null) then deg = opts.DisplayedDegree;
      
    padics(
        p,
        f,
        g,
        DisplayedDegree => opts.DisplayedDegree,
        ComputedDegree => opts.ComputedDegree,
        PositiveCoefficients=>opts.PositiveCoefficients
        ) 
);

-- Making a PadicSeries without the added computation of polynomial construction
padics(ZZ, Function, Thing) := LazySeries => opts -> (p, f, computedPoly) -> ( 
    R := ring computedPoly;
    newComputedPoly := truncate(opts.ComputedDegree, computedPoly, Prime => p);

    new PadicSeries from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => truncate( opts.DisplayedDegree, newComputedPoly, Prime => p),
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            Degree => infinity,
            valueList => toAdics(p, computedPoly, PositiveCoefficients=>opts.PositiveCoefficients)
        }
    }
);

-*
padics(Ring, ZZ, List) := PadicSeries => opts -> (R, p, L) -> (
    variables := vars(gens R +1);
    f := variables -> coefficient()


    new PadicSeries from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            valueList => L
        }
    }

)
*-

padics(PadicSeries, Function) := PadicSeries => opts -> (L, function) -> (    
    local tempLPower;
    R := L.seriesRing;
    p := L.primeNumber;
    f := x -> sub(function x, R);

    s := 0;
    oldDeg := L.cache.ComputedDegree;
    origComputed := L.cache.computedPolynomial;
    
    --first we compute the new computed polynomial
    newCompPoly := sum( apply(oldDeg+1, i -> truncate(oldDeg, (f i)*origComputed^i, Prime => p))); --maybe instead we should do L^i, and store that in the cache, that would probably be better, instead of taking the polynomial to the i.

    newFunction := v -> (
        sumV := sum v;

        tempOrigComputed := L.cache.computedPolynomial;

        tempComputed := sub(sum( apply(sumV+1, i -> truncate(sumV, (f i)*tempOrigComputed^i)) ), L.seriesRing);
        coefficient(v, tempComputed)
    );

    padics(
        p,
        newFunction,
        newCompPoly,
        DisplayedDegree => L#cache.DisplayedDegree,
        ComputedDegree=> L#cache.ComputedDegree,
        PositiveCoefficients=>opts.PositiveCoefficients
        )

);
--*******************************************************
--Methods that use PadicSeries object and its constructors
--*******************************************************

-- Changing degree of LazySeries

changeDegree(PadicSeries, ZZ) := LazySeries => (L, newDeg) -> (

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
            if L#cache#?"FastChangeComputedDegree" then (
                if (debugLevel > 0) then print "changeDegree: using cached fast degree change function";
                tempPoly = (L#cache#"FastChangeComputedDegree")(newDeg);                
            )
            else( 
                if (debugLevel > 0) then print "changeComputeDegree: using slow degree change function";
                tempPoly = (calculatePolynomial(newDeg, R, f));--we have no choice but to call this
            );
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
changeComputedDegree(LazySeries, ZZ) := LazySeries => (L, newDeg) -> (
    if (debugLevel > 0) then print "changeComputedDegree: starting";

    oldDeg := L.cache.DisplayedDegree;
    oldPoly := L.cache.displayedPolynomial;

    f := L#coefficientFunction;
    R := L#seriesRing;
    local tempPoly;

    if (debugLevel > 0) then print "tried to change computed degree to a lower value, nothing done";

    if newDeg <= oldDeg then L
    else if newDeg > oldDeg then (
        
        L#cache#ComputedDegree = newDeg;
        if L#cache#?"FastChangeComputedDegree" then (
            if (debugLevel > 0) then print "channgeComputedDegree: using cached fast degree change function";
            tempPoly = (L#cache#"FastChangeComputedDegree")(newDeg);
        )
        else(
            if (debugLevel > 0) then print "changeComputeDegree: using slow degree change function";
            tempPoly = (calculatePolynomial(newDeg, R, f));  
        );
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
-- Coefficient function overload for p-adics
coefficient(VisibleList, PadicSeries) := (L, M) -> (
    R := M.seriesRing;
    p := M.primeNumber;
    variables := {sub(p, R)} | toList gens R;
    monomial := product(apply(#variables, i->(variables#i)^(L#i)));
    H := M.cache.valueList;

    H#monomial
);

ring(PadicSeries) := L -> L.seriesRing; 

isUnit(PadicSeries) := Boolean => L -> (
    constantTerm := L.cache.valueList#(sub(1,L.seriesRing));
    if(constantTerm == 0) then false
    else true
);

truncate(ZZ, PadicSeries) := {} >> opts -> (n, L) -> (
    p := L.primeNumber;
    f := L.cache.displayedPolynomial;
    truncate(n,f, Prime => p)
    

);
