--*************************************************
--*************************************************
-- 
--*************************************************
--*************************************************
newPackage(
        "LazySeriesPackage",
        Version => "2.0", 
        Date => "5/14/2021",
        Authors => {
          {Name => "Chris Cunningham", 
          Email => "cjc258@cornell.edu"},
          
	     {Name => "Jason McCullough", 
	     Email => "jmccullo@math.ucr.edu",
	     HomePage => "http://www.math.ucr.edu/~jmccullo/"},

	     {Name => "Bart Snapp", 
	     Email => "snapp@math.ohio-state.edu",
	     HomePage => "http://www.math.ohio-state.edu/~snapp/"},
	
          {Name => "Karl Schwede", 
	     Email => "schwede@math.utah.edu",
	     HomePage => "https://www.math.utah.edu/~schwede/"},
	
          {Name => "Annie Giokas", 
	     Email => "u1304541@utah.edu",
	     HomePage => "https://github.com/annie-giokas"} },

        Headline => "A package for implementing power series and its calculations",
        DebuggingMode => true,
        Reload => true,
        AuxiliaryFiles=>true        
        )

export{
  -- HelperFunctions
    "toMonomial",
    "maximumsList",
    "toBinary",
    "calculatePolynomial",

    -- LazySeries
    "LazySeries",
    "lazySeries",
    "coefficientFunction",
    "constantTerm",
    "seriesRing",
    "DisplayedDegree", 
    "ComputedDegree",  
    "displayedPolynomial",
    "computedPolynomial",

    -- Methods
    "changeDegree",

 
    -- Basic Operations
    
    "zeroSeries",
    "oneSeries"

}


load "./LazySeriesPackage/LazySeriesMethods.m2"
load "./LazySeriesPackage/BasicOperations.m2"


--DOCUMENTATION
beginDocumentation()
load "./LazySeriesPackage/LazySeriesMethodsDoc.m2"
load "./LazySeriesPackage/BasicOperationsDoc.m2"



-- TESTS
load "./LazySeriesPackage/Tests/ConstructionTests.m2"
load "./LazySeriesPackage/Tests/HelperFunctionTests.m2"
load "./LazySeriesPackage/Tests/BasicOperationsTests.m2"

end