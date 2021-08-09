--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================

--===================================================================================
-- CONSTRUCTING SERIES


export{       "listPolynomial",
       "toBinary", 
       "zeroSeries", 
       "oneSeries",
       "tempCalculations", 
       "seriesCalculation", 
       "binDigit",
       "maclaurinSeries"
       }

-- Helper functions
export{"changeDegree",
       "makeSeriesCompatible",
       "getCoefficient",
       "getPolynomial",
       "getFunction"}


-*SemiMutableHashTable = new Type of HashTable{
    mutable => {}
    immutable => {}
}

*-



------------------------------------------- HELPER FUNCTIONS -----------------------------------------------------------
-*
toMonomial = (L,S) ->(-- CREDITS to: Jessica Sidman -- ADD THIS LATER WITH THE MYFUN FUNCTION
     variableList := flatten entries vars S;
     m := 1;
     for i from 0 to (#L-1) do(
     	  m = m*(variableList)_i^(L#i);
     	  );
     m
)


*-
--myFun = L -> coefficient(toMonomial(L, ring f), f) -- USE THIS FOR RINGELEMENT TO LAZYSERIES CONSTRUCTOR

-- Get coefficient value based on index
getCoefficient = method()
getCoefficient(LazySeries, List) := LazySeries =>  (S,coefficientVector) -> (
    
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

getCoefficient(LazySeries, Sequence) := LazySeries =>  (S,coefficientVector) -> (
    
    sub(S#coefficientFunction toSequence coefficientVector, S#seriesRing) -- important to output proper ring element as value
);

-- overloading coefficient method
coefficient(Sequence, LazySeries) := (c,L) ->{
    --checks cache of LazySeries first and grabs the coefficients if available
    -- else change the computed degree up to the level we need and compute the polynomial up to the same level
    -- change computedDegree 
}
coefficient(Sequence, RingElement) := (c, P) ->( -- use Jessica's function
)
coefficient(RingElement, LazySeries) := (M, L) ->(
    -- check if monomial
    -- see existing coefficient function

)


-- Multiplication of two LazySeries
LazySeries * LazySeries := LazySeries => (A,B) -> (
    if not (A#seriesRing === B#seriesRing) then error "Rings of series do not match"; -- checks if using same ring

    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    ringZeroes := numgens R:0;

    -*
    newFunction := coefficientVector -> (
        s := 0;
        L := toList ringZeroes .. toList coefficientVector;
        for i from 0 to #L-1 do
            s = s + ((f toSequence(L#i)) * g toSequence(toList coefficientVector -  (L#i)));    
        s
    );
    *-

    newFunction := coefficientVector -> (
        tempDegree := sum coefficientVector;
        a := changeDegree(A, tempDegree);
        b := changeDegree(B, tempDegree);

        P1 := a#displayedPolynomial;
        P2 := b#displayedPolynomial;

        P = P1*P2;

        -- grab coefficient vector of P

    );

    newDegree := min(A#displayedDegree, B#displayedDegree);

    lazySeries(R, newFunction, displayedDegree =>  newDegree, computedDegree => newDegree) -- REMOVED DISPLAYED DEGREE FOR A BIT
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

    -- NEED TO ADD OPTION FOR NEGATIVE POWERS AS WELL!!!!!!!!!!!! once inversion is complete
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

inverse(LazySeries, ZZ) := LazySeries => (S, deg) -> (
    -- first check if it is a unit in the ring
    --if isUnit(S) == false then error "Cannot invert series because it is not a unit";
    g := (-1) * ((S / S#constantTerm)-1); -- We want to turn S into a_0(1-g) to then use 1+g+g^2+g^3+...
    (S#constantTerm) * maclaurinSeries (g, deg)
    
);
-- Division of two LazySeries
LazySeries / LazySeries := LazySeries => (A, B)->(
    A * inverse(B)
)
-- Dividing a number by LazySeries
Number / LazySeries := LazySeries => (n, B)->(
    n * inverse(B)
)

--===================================================================================    

-- Displays the series in a more organized way
pretty LazySeries := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#displayedDegree+2,
                i -> part_i(select(s#displayedPolynomial, i -> degree i >= {s#displayedDegree})) -- NEEDS TO BE FIXED BECAUSE DEGREE IN GRADED RINGS IS A LIST NOT AN INTEGER
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e, Sum) then
        new Parenthesize from {e} 
        else e
);

expression Series := s -> pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"

--===================================================================================