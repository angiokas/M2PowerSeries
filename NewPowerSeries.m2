--*************************************************
--*************************************************
-- 
--*************************************************
--*************************************************
newPackage(
        "NewPowerSeries",
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
    "lazySeries",
    "coefficientFunction",
    "constantTerm",
    "seriesRing",
    "LazySeries",
    "DisplayedDegree", 
    "ComputedDegree",  
    "displayedPolynomial",
    "computedPolynomial",
    "changeDegree",
    "toMonomial",
    "maximumsList",
    "toBinary",
    "calculatePolynomial",
    "dog"
}
LazySeries = new Type of MutableHashTable;
dog = new Type of HashTable;

load "./NewPowerSeries/PowerSeriesFunctions.m2"



--DOCUMENTATION
beginDocumentation()
load "./NewPowerSeries/PowerSeriesFunctionsDoc.m2"


-- TESTS
load "./NewPowerSeries/Tests/ConstructionTests.m2"
load "./NewPowerSeries/Tests/HelperFunctionTests.m2"
load "./NewPowerSeries/Tests/BasicOperationsTests.m2"

end