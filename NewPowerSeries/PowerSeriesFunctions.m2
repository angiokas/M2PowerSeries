--*************************************************
--Basic functions of Power Series
--*************************************************
--===================================================================================



Series = new Type of HashTable

--===================================================================================
series = method(Options => {Degree => 5})

-- method that creates a series using a ring element (basically treats the ring elements as a series with rest of the coefficients as 0)
-- n is the amount of terms you want to compute for the series
-- f is the ring element used as the base 
-- degree - Displayed degree
-- maxDegree - maximum degree mathematically
-- computedDegree - Highest power that has been computed
-- 


series(ZZ, RingElement) := Series => opts -> (n,f) -> (
     new Series from {degree => n, --we want to change this to disaplyedDegree
      maxDegree => max((first degree f), n), -- here degree is a method for polynomials
      computedDegree => max((first degree f), n), 
      polynomial => f,
	  setDegree => ((oldPolynomial,oldComputedDegree,newDegree) -> (oldPolynomial,oldComputedDegree))}
     );

series(RingElement) := Series => opts -> f -> (
     new Series from {degree => opts.Degree,
      maxDegree => max((first degree f), opts.Degree), 
      computedDegree => max((first degree f), opts.Degree), 
      polynomial => f}
     );
-- note: opts -> is needed because series method has options
--===================================================================================
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
                        degree => (min(n,S#maxDegree)),
                        setDegree=> S#setDegree}
     );
--===================================================================================

-- Selects the terms of a polynomial up to degree specified
truncate(ZZ,RingElement) := RingElement => (n,f) -> part(,n,f);

--===================================================================================

toPolynomial = method()

-- Converts a Power series object into a polynomial by taking the part of the series up to default power 5
-- n is the power you want to truncate it at

toPolynomial(Series) := RingElement => s -> toPolynomial(s#degree,s);
toPolynomial(ZZ,Series) := RingElement => (n,s) -> truncate(n,(setDegree(n,s))#polynomial);

--===================================================================================
pretty Series := s -> net new Sum from apply(
    apply(
        select(
            apply(
                s#degree+2,
                i -> part_i(truncate(s#degree, s#polynomial))
            ),
            p-> p!=0),
        expression
        ),
    e -> if instance(e,Sum) then
        new Parenthesize from {e} 
        else e
)

expression Series := s -> pretty s + expression "O(" expression(s#degree+1) expression ")"
net Series := s -> net pretty s + expression "O(" expression(s#degree+1) expression ")"
toString Series := s -> toString pretty s + expression "O(" expression(s#degree+1) expression ")"
tex Series := s -> tex pretty s + expression "O(" expression(s#degree+1) expression ")"
html Series := s -> html pretty s + expression "O(" expression(s#degree+1) expression ")"

--===================================================================================