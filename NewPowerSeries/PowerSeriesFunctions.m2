--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================
Series = new Type of HashTable

--===================================================================================
-- CONSTRUCTING SERIES
series = method(Options => {Degree => 5})

export{"setPrecision","coefficientFunction", "getCoefficient", "termVariables",
       "variables","displayedPolynomial","seriesRing","formalTaylorSeries",
       "toBinary"}

LazySeries = new Type of HashTable
lazySeries = method(Options => {Degree => 2})
--LAZY SERIES

-- f is the function which has to have the same amount of inputs as there are variables
lazySeries(Ring, Function) := LazySeries => opts -> (R, function) -> (
  
    ringVariables := gens R;
    
    try function (numgens R:0) then 1 -- checks to see if function was inputted correctly
    else error "Number of inputs of given function does not match number of ring generators";

    combinations := {};
    for j from 0 to opts.Degree do
        combinations = append(combinations, compositions (#ringVariables,j)); 
    combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left

    s :=0;
     -- add opts.Degree terms to s.
    for j from 0 to #combinations-1 do 
        s = s+ (function toSequence(combinations#j))* product(apply(#ringVariables, i -> (ringVariables#i)^((combinations#j)#i)));
    print s;
     -- Making a new lazySeries
     new LazySeries from {
        displayedDegree => opts.Degree,
        computedDegree => opts.Degree,
        maxDegree => infinity,
        displayedPolynomial => s,
        coefficientFunction => function,
        getCoefficient => (coefficientVector)-> function (toSequence coefficientVector),
        termVariables => ringVariables,
        seriesRing => R
    }
);

-- Getting coefficient value

getCoefficient = method()
getCoefficient(LazySeries, List) := LazySeries =>  (S,coefficientVector) -> (
    print S#coefficientFunction;
    print S#coefficientFunction toSequence coefficientVector;
);

-- Converting to binary
toBinary = method()
toBinary(ZZ) := n ->(
    b := "";
    num := floor(log(2, n)); -- Had to use this because n in the for loop settings won't change
    for i from 0 to num do(
        b = concatenate{toString(n % 2), b};
        n = (n//2);
    );
    b
);
-- Raising LazySeries by nth power
LazySeries ^ ZZ := LazySeries => (S,n) -> (
    bin := toBinary(n);
    temporaryCalculations := {};
);





--LazySeries Addition
LazySeries + LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := vars(1..(numgens R));
    newFunction:= variables-> f variables + g variables;
    lazySeries(R, newFunction)
);

LazySeries - LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    variables := vars(1..(numgens R));
    newFunction:= variables-> f variables - g variables;
    lazySeries(R, newFunction)
);
-- MULTIPLICATION
LazySeries * LazySeries := LazySeries => (A,B) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := A#coefficientFunction;
    g := B#coefficientFunction;
    R := A#seriesRing;
    ringZero := numgens R:0;
    
    newFunction := coefficientVector -> (
        s := 0;
        L := toList ringZero .. toList coefficientVector;
        for i from 0 to #L-1 do
            s = s + ((f toSequence(L#i)) * g toSequence(toList coefficientVector -  (L#i)));    
        s
    );
    lazySeries(R, newFunction)
);


-- Adding scalars
Number + LazySeries := LazySeries => (n,S) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    variables := vars(1..(numgens R));

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZero then n + (f variables)
                               else (f variables));
    lazySeries(R, newFunction)
);

LazySeries + Number := LazySeries => (S,n) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    if(n == 0) then lazySeries(R, variables -> 0);

    newFunction:= variables-> (if variables == ringZero then (f variables) + n
                               else (f variables));
    lazySeries(R, newFunction)
);

Number - LazySeries := LazySeries => (n,S) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators, not the zero of the ring

    variables := vars(1..(numgens R));

    if(n == 0) then S;

    newFunction:= variables-> (if variables == ringZero then n - (f variables)
                               else (f variables)) ;
    lazySeries(R, newFunction)
);

LazySeries - Number := LazySeries => (S,n) -> (
   -- if A#seriesRing != B#seriesRing then error "Rings of series do not match"; -- cannot compare Rings in Macaulay2
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    if(n == 0) then lazySeries(R, variables -> 0);

    newFunction:= variables-> (if variables == ringZero then (f variables) - n
                               else (f variables))  ;
    lazySeries(R, newFunction)
);
-- Multilplying LazySeries by a scalar
Number * LazySeries := LazySeries => (n,S) -> (
    f := S#coefficientFunction;
    R := S#seriesRing;

    if(n == 0_R) then lazySeries(R, variables -> 0);

    variables := vars(1..(numgens R));

    newFunction:= variables-> (n * (f variables));
    lazySeries(R, newFunction)
);

LazySeries * Number := LazySeries => (S,n) -> (
    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0;
    
    variables := vars(1..(numgens R)); -- Could replace with termVariables from the constructor??

    if(n == 0_R) then lazySeries(R, variables -> 0); -- 0_R is the zero of the ring

    newFunction:= variables-> ((f variables) * n);
    lazySeries(R, newFunction)
);
-- Exact division by scalar (the `/` binary operator)
LazySeries / Number := LazySeries => (S,n) -> (
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    newFunction:= variables-> (f variables) / n;
    lazySeries(R, newFunction)
);
-- Division with remainder by scalar (the `//` binary operator)
LazySeries // Number := LazySeries => (S,n) -> (
    if n == 0 then error "Cannot divide by 0";

    f := S#coefficientFunction;
    R := S#seriesRing;
    ringZero := numgens R:0; -- sequence of 0s the amount of the ring generators 
    
    variables := vars(1..(numgens R));

    newFunction:= variables-> (f variables) // n;
    lazySeries(R, newFunction)
);
-- Division of scalar by LazySeries










-- method that creates a series using a ring element (basically treats the ring elements as a series with rest of the coefficients as 0)
-- n is the amount of terms you want to compute for the series
-- f is the ring element used as the base 
-- degree - Displayed degree
-- maxDegree - maximum degree mathematically
-- computedDegree - Highest power that has been computed

series(ZZ, RingElement) := Series => opts -> (n,f) -> (
     new Series from {displayedDegree => n, --we want to change this to disaplyedDegree
      maxDegree => max((first degree f), n), -- here degree is a method for polynomials
      computedDegree => max((first degree f), n), 
      polynomial => f,
	  setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (oldPolynomial,oldComputedDegree)), -- Does not do anything really
      setPrecision => (newDisplayedDegree)-> series(newDisplayedDegree, f)} -- added new method
     );
-- note: opts -> is needed because series method has options
series(RingElement) := Series => opts -> f -> ( 
     new Series from {displayedDegree => opts.Degree,
                      maxDegree => max((first degree f), opts.Degree), 
                      computedDegree => max((first degree f), opts.Degree), 
                      polynomial => f}
     );

-- Lazy Series: making a series using an explicit formula
series(RingElement, Function) := Series => opts -> (X,f) -> (
     -- Start with the zero polynomial.
     s:=0;
     -- add opts.Degree terms to s.
     for i from 0 to opts.Degree do s = s + (f i)*X^i;
     
     -- now make a new series.
     new Series from {displayedDegree => opts.Degree,
        maxDegree => infinity,
        computedDegree => opts.Degree,
        polynomial => s, 
        -- setDegree takes an old polynomial, the old computed degree, and a new degree, and needs
	      -- to know how to tack on the new terms to the old polynomial.
	      setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (newPolynomial := oldPolynomial;
		              for i from oldComputedDegree + 1 to newDegree do newPolynomial = newPolynomial + (f i)*X^i;
			      (newPolynomial,max(oldComputedDegree,newDegree))
		    ))});




--===================================================================================
--FUNCTIONS ASSOCIATED WITH SERIES
-- polynomial is the 
-- computedDegree is
-- maxDegree is
-- degree is
-- setDegree 

setDegree = method()
setDegree(ZZ, Series) := Series =>  (n,S) -> (
    if n > S.maxDegree then
        error concatenate("Cannot exceed max degree ", toString S.maxDegree, " for this power series.");
    (f,c) := S#setDegree (S#polynomial,S#computedDegree,n);
    new Series from {
        polynomial => f,
        computedDegree => c,
        maxDegree => S#maxDegree,
        displayedDegree => (min(n,S#maxDegree)),
        setDegree=> S#setDegree
    }
);


--===================================================================================

-- Selects the terms of a polynomial up to degree specified
truncate(ZZ,RingElement) := RingElement => (n,f) -> part(,n,f);

--===================================================================================
-- Converts a Power series object into a polynomial by taking the part of the series up to default power 5
-- n is the power you want to truncate it at
toPolynomial = method()
toPolynomial(Series) := RingElement => s -> toPolynomial(s#displayedDegree,s);
toPolynomial(ZZ,Series) := RingElement => (n,s) -> truncate(n,(setDegree(n,s))#polynomial);
--===================================================================================
-- Outputs the degree of a Series
degree(Series) := Series => F -> F#displayedDegree;

--===================================================================================
-- Returns the domninant term of the series
dominantTerm = method()
dominantTerm(Series) := RingElement => S -> (
     -- This is bad, it depends on the monomial order:last terms toPolynomial S;
     -- This seems slow but at least correct:
     f := toPolynomial S;
     minDegree := min apply(terms f, i -> first degree i);
     part(minDegree,minDegree,f)
     )

--===================================================================================    
-- Checks if the series is a unit (i.e has an inverse) by checking if the domninant term is a unit
isUnit(Series) := Boolean => A -> isUnit(dominantTerm(A));

-- 
makeSeriesCompatible = method()
makeSeriesCompatible(Series,Series) := Sequence => (A,B) -> (
     newComputedDegree := min(degree(A),degree(B));
     (
	  new Series from {displayedDegree => newComputedDegree, 
	       	    	   computedDegree => newComputedDegree,
			   maxDegree => A.maxDegree,
			   polynomial => truncate(newComputedDegree,A.polynomial),
			   setDegree => A#setDegree},
	  new Series from {displayedDegree => newComputedDegree, 
	       	    	   computedDegree => newComputedDegree,
			   maxDegree => B.maxDegree,
			   polynomial => truncate(newComputedDegree,B.polynomial),
			   setDegree => B#setDegree}
     	  )
     
     
     );
-- SERIES ARITHMETIC
--ADDITION
Series + Series := Series => (A,B) -> (
     (A',B') := makeSeriesCompatible(A,B);
     new Series from {displayedDegree => min(A#displayedDegree,B#displayedDegree), maxDegree => min(A'.maxDegree,B'.maxDegree), computedDegree => A'.computedDegree, polynomial => A'.polynomial + B'.polynomial, 
	  setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (
		    if newDegree > oldComputedDegree then (
		    	 newA := setDegree(newDegree,A);
		    	 newB := setDegree(newDegree,B);
		    	 (truncate(newDegree,newA.polynomial + newB.polynomial), newDegree)
			 )
		    else (oldPolynomial, oldComputedDegree)
		    )
	       )}
);
-- SUBTRACTION
Series - Series := Series => (A,B) -> (
     (A',B') := makeSeriesCompatible(A,B);
     new Series from {displayedDegree => min(A#displayedDegree,B#displayedDegree), maxDegree => min(A'.maxDegree,B'.maxDegree), computedDegree => A'.computedDegree, polynomial => A'.polynomial - B'.polynomial, 
	  setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (
		    if newDegree > oldComputedDegree then (
		    	 newA := setDegree(newDegree,A);
		    	 newB := setDegree(newDegree,B);
		    	 (truncate(newDegree,newA.polynomial - newB.polynomial), newDegree)
			 )
		    else (oldPolynomial, oldComputedDegree)
		    )
	       )}
);

-- MULTIPLICATION
Series * Series := Series => (A,B) -> (
     (A',B') := makeSeriesCompatible(A,B);
     newComputedDegree := A'.computedDegree;
     -- newComputedDegree should be changed when we do Laurent Series
     new Series from {displayedDegree => min(A#displayedDegree,B#displayedDegree), maxDegree => min(A'.maxDegree,B'.maxDegree), computedDegree => newComputedDegree, polynomial => truncate(newComputedDegree ,toPolynomial(A') * toPolynomial(B')), 
	  setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (
		    if newDegree > oldComputedDegree then (
		    	 newA := setDegree(newDegree,A);
		    	 newB := setDegree(newDegree,B);
		    	 (truncate(newDegree, newA.polynomial * newB.polynomial), newDegree)
			 )
		    else (oldPolynomial, oldComputedDegree)
		    )
	       )}
);




--===================================================================================    
-- Displays the series in a more organized way
pretty Series := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#displayedDegree+2,
                i -> part_i(truncate(s#displayedDegree, s#polynomial))
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e,Sum) then
        new Parenthesize from {e} 
        else e
)

expression Series := s -> pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#degree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#displayedDegree+1) expression ")"

--===================================================================================
