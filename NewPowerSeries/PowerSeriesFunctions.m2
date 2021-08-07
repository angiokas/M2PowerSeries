--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
export{
--PowerSeriesFunctions (PowerSeriesFunctions.m2)
    "displayedDegree", 
    "computedDegree",
    "lazySeries",
    "coefficientFunction",
    "constantTerm",
    "variables", 
    "displayedPolynomial",
    "computedPolynomial",
    "seriesRing"
}
LazySeries = new Type of MutableHashTable

lazySeries = method(Options => {Degree => 2, displayedDegree => 3, computedDegree => 3})
--LAZY SERIES

-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (

    ringVariables := gens R;
    ringZeroes := numgens R:0;
    f := 0;
    if (numgens R == 1) then f = i -> sub(function i#0, R)
    else f = ringVariables -> sub(function ringVariables, R);

    try f ringZeroes then 1 -- checks to see if f was inputted correctly by plugging in (0 0 ... 0)
    else error "Number of inputs of given function does not match number of ring generators";

    combinations := {};
    deg := opts.displayedDegree;
    if (class opts.displayedDegree === List) then deg = sum opts.displayedDegree;
    
    for j from 0 to deg do -- IT WONT WORK WITH MULTI GRADED RINGS WITH DEGREES THAT ARE LISTS, can use `from ringZeroes .. to opts.displayedPolynomial`, but it gives error somewhere else down the line
        combinations = append(combinations, compositions (#ringVariables, j)); 
    combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left

    s := 0;
     -- add opts.Degree terms to s.
    for j from 0 to #combinations-1 do 
        s = s + (f toSequence(combinations#j)) * product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));-- ADDED SUB HERE
    if debugLevel > 2 then print s;
     -- Making a new lazySeries
    L := new LazySeries from {
        
        constantTerm => f ringZeroes, -- immutable
        coefficientFunction => f, --immutable
        seriesRing => R, -- immutable
        cache => new CacheTable from { -- contains everything mutable
            displayedDegree => opts.displayedDegree,
            computedDegree => opts.computedDegree,
            displayedPolynomial => s,
            computedPolynomial => s
        } -- store powers as well
    };
    print (L#cache)#displayedPolynomial;
    L 
);

-- Converting ring elements and polynomials into LazySeries
lazySeries(RingElement) := LazySeries => opts -> P -> (-- Isn't outputting correct degree for the polynomial
    listPolynomial := listForm P; -- USES EXTRA MEMORY AND COMPUTING ITME
    R := ring P;
    variables := gens R;
    if debugLevel > 1 then print variables;

    h := variables ->(
    for i from 0 to #listPolynomial-1 do(
        
        if variables == (toSequence(listPolynomial#i)#0) then (
            if debugLevel > 1 then print variables;
            if debugLevel > 1 then print toSequence(listPolynomial#i)#0;
            if debugLevel > 1 then print "SUCCESS";
            return (listPolynomial#i)#1;
            )
        );
        0
    );
    lazySeries(R, h, displayedDegree => sum (degree P), computedDegree => sum (degree P)) -- temporary fix, but will have to make list degrees work in general
);

lazySeries(LazySeries, Function) := LazySeries => opts -> (S, function) -> (    
    R := S#seriesRing;
    f := x -> sub(function x, R);

    s:=0;
     -- add opts.Degree terms to s.
    for i from 0 to S#displayedDegree do (
        s = s + (f i)*S^i;
        if debugLevel >2 then print s#displayedPolynomial;
        );
    
    if debugLevel >2 then print s;
     -- Making a new lazySeries
    new LazySeries from {
        displayedDegree => s.displayedDegree,
        computedDegree => s.computedDegree,
        constantTerm => s#constantTerm,
        displayedPolynomial => s#displayedPolynomial,
        coefficientFunction => s#coefficientFunction,
        -- getCoefficient => coefficientVector-> f (toSequence coefficientVector),
        seriesRing => R,
        cache => new CacheTable from {

        } -- for calculating powers!!!!!! IMPLEMENTTT
    }
);