--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================

Series = new Type of HashTable

--===================================================================================
-- CONSTRUCTING SERIES
series = method(Options => {Degree => 5})

-- method that creates a series using a ring element (basically treats the ring elements as a series with rest of the coefficients as 0)
-- n is the amount of terms you want to compute for the series
-- f is the ring element used as the base 
-- degree - Displayed degree
-- maxDegree - maximum degree mathematically
-- computedDegree - Highest power that has been computed
-- 

export{"setPrecision", "applyList"}
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

--MULTIVARIABLE EXPERIMENT - worked!

--First let us add a method that enables us to apply a list to a list
applyList = method()
applyList(Function, List, List) := (f,l1,l2)->(
    if (#l1 != #l2) then
        error("lists not of equal length"); -- first checks that list lengths are equal
    
    l := {}; -- starting with an empty list
    for i from 0 to (#l1-1) do
        l = append(l,f(l1#i,l2#i));

    return l;
)

series(List, Function, ZZ) := Series => opts -> (variables,f, totalDeg) -> (
    -- Start with the zero polynomial.
    s:=0;
    -- n is the number of variables
    n:= #variables;
    -- 
    p:= (a,b)->a^b;
    --
    combinations := {};
    for j from 0 to totalDeg do
        combinations = append(combinations, compositions (n,j)); 
    combinations = flatten combinations; -- flattens the the nested list, so that only {i_1,i_2,...,i_n} types are left
    
     -- add opts.Degree terms to s.
    for i from 0 to #combinations-1 do
        s = s+ (f i)* product(applyList(p,variables, combinations#i));
    
     -- now make a new series.
     new Series from {displayedDegree => totalDeg,
        maxDegree => infinity,
        computedDegree => totalDeg,
        polynomial => s,
        setPrecision => (newDeg)-> series(variables, f, newDeg )
        }
);


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
        new Series from {polynomial => f,
                        computedDegree => c,
                        maxDegree => S#maxDegree,
                        displayedDegree => (min(n,S#maxDegree)),
                        setDegree=> S#setDegree}
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
