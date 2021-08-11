--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
--PowerSeriesFunctions (PowerSeriesFunctions.m2)

export{
    "lazySeries",
    "coefficientFunction",
    "constantTerm",
    "seriesRing",

    "displayedDegree", 
    "computedDegree",  
    "displayedPolynomial",
    "computedPolynomial"
}
export{
    "toMonomial",
    "maximumsList"
}

LazySeries = new Type of MutableHashTable

lazySeries = method(Options => {Degree => 2, displayedDegree => 3, computedDegree => 3})

-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
--try f ringZeroes then 1 -- checks to see if f was inputted correctly by plugging in (0 0 ... 0)
    --else error "Number of inputs of given function does not match number of ring generators"; -- I think this check is a bit useless since the problem could be something else besides the number of inputs
    print "HELLO";
    ringVariables := gens R;
    ringZeroes := numgens R:0;
    f := 0;

    combinations := {};
    start := 0;
    deg := opts.displayedDegree;

    if (class opts.displayedDegree === List) then deg = sum opts.displayedDegree;
    s := 0;

    if (numgens R == 1) then (
        f = x -> sub(function x, R);
        ringZeroes = 0;

        for i from 0 to deg do s = s + (f i)*(ringVariables#0)^i;
        )
    else (
        f = ringVariables -> sub(function ringVariables, R);

         for j from start to deg do -- IT WONT WORK WITH MULTI GRADED RINGS WITH DEGREES THAT ARE LISTS, can use `from ringZeroes .. to opts.displayedPolynomial`, but it gives error somewhere else down the line
            combinations = append(combinations, compositions (#ringVariables, j)); 
        combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left

    
    print "HELLO";
     -- add opts.Degree terms to s.
    for j from 0 to #combinations-1 do (
        print toSequence(combinations#j);
        s = s + (f toSequence(combinations#j)) * product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));
        );
    );

    
     -- Making a new lazySeries
    L := new LazySeries from {
        constantTerm => f ringZeroes,
        coefficientFunction => f,
        seriesRing => R,

        cache => new CacheTable from { -- contains everything mutable
            displayedDegree => opts.displayedDegree,
            displayedPolynomial => s,
            computedDegree => opts.computedDegree,
            computedPolynomial => s
        } -- store powers as well
    };
    print (L#cache)#displayedPolynomial;
    L 
);


-- Converting ring elements and polynomials into LazySeries
lazySeries(RingElement) := LazySeries => opts -> P -> ( 
    R := ring P;
    variables := gens R;
    newFunction := variables -> coefficient(variables, P);

    lazySeries(R, newFunction, displayedDegree =>sum (degree P), computedDegree => sum (degree P)) 
);


lazySeries(LazySeries, Function) := LazySeries => opts -> (S, function) -> (    
    R := S#seriesRing;
    f := x -> sub(function x, R);

    s:=0;
     -- add opts.Degree terms to s.
    for i from 0 to S#displayedDegree do (
        s = s + (f i)*S^i;
        );    
     -- Making a new lazySeries
    new LazySeries from {
        
        constantTerm => s#constantTerm,
        coefficientFunction => s#coefficientFunction,
        seriesRing => R,

        cache => new CacheTable from {
            displayedDegree => s.displayedDegree,
            computedDegree => s.computedDegree,
            displayedPolynomial => s#displayedPolynomial,
            computedPolynomial => s#displayedPolynomial

        } -- for calculating powers!!!!!! IMPLEMENTTT
    }
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Changing degree of LazySeries
changeDegree = method()
changeDegree(LazySeries, ZZ) := LazySeries => (S, newDeg) -> (

    oldDeg := S#displayedDegree;
    f := S#coefficientFunction;
    R := S#seriesRing;

    if newDeg == oldDeg then S
    else if newDeg > oldDeg then (
        lazySeries(R, f, displayedDegree => newDeg, computedDegree => newDeg)
        )
    else lazySeries(R, f, displayedDegree => newDeg, computedDegree => oldDeg) -- needs to truncate the displauedPolynomial too
);



--toMonomial is a function that takes an exponent vector in the form of a list L and a polynomial ring S.  It returns a monomial m with exponent vector L. author:Jessica Sidman
toMonomial = (L, S) ->(
     variableList := flatten entries vars S;
     m := 1;
     for i from 0 to (#L-1) do(
     	  m = m*(variableList)_i^(L#i);
     	  );
     m
);

-- overloading coefficient method
coefficient(VisibleList, RingElement) := (L, P) -> coefficient(toMonomial(L, ring P), P); -- USE THIS FOR RINGELEMENT TO LAZYSERIES CONSTRUCTOR
coefficient(ZZ, RingElement) := (n, P) -> coefficient(toMonomial({n}, ring P), P);

coefficient(VisibleList, LazySeries) := (indexVector, L) ->(
    --need to recalculate computedPolynomial if maximumsList(indexVector) is higher than the highest monomial 
    -- need to do changeDegree(L, maximumsList()); 
    coefficientValues := {};

    f := 0;
    h := 0;
    
    for j from 0 to (#indexVector)-1 do(
        f := t ->(
                val := coefficient(indexVector#j, t.cache.computedPolynomial);
                << "Added value " << val << " with key " << indexVector#j << "to cache" << endl;
                val
                );
        h = (cacheValue indexVector#j) f;

        coefficientValues = append(coefficientValues,  h L);
    );
    coefficientValues

    --checks cache of LazySeries first and grabs the coefficients if available
    -- else change the computed degree up to the level we need and compute the polynomial up to the same level
    -- change computedDegree 
);


coefficient(RingElement, LazySeries) := (M, L) ->(
    print ;
    -- check if monomial
    -- see existing coefficient function
);


-- Returns an n-tuple with maximum element from each index fromlist of n-tuples
maximumsList = method() -- WORKS

maximumsList(VisibleList) := l -> (-- ASSUMES THAT THE LIST PROVIDED HAS ELEMEMNTS OF THE SAME LENGTH i.e {{a,b},{c,d},{l,m}} where #{a,b}==#{c,d}==#{l,m}==2
elementLength := #(l#0);
maximums := {};
maximumValue := 0;
for j from 0 to (elementLength-1) do(
    maximumValue = max(apply(l, i-> i#j));
    maximums = append(maximums,maximumValue );
);

maximums
);



----------------------------------------
--returns the ring of a LazySeries
ring(LazySeries) := L -> L#seriesRing;

-- Returns displayed polynomial
getPolynomial = method()
getPolynomial(LazySeries):= L -> L.cache.displayedPolynomial;