--*************************************************
--*************************************************
-- 
--*************************************************
--*************************************************
newPackage(
        "LazyPowerSeries",
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
        PackageImports => {"Truncations"},
        Reload => true,
        AuxiliaryFiles=>true        
        )

export{
  -- HelperFunctions
    "toMonomial",
    "maximumsList",
    "toBinary",
    "calculatePolynomial",
    "calculatePartialSeries",
    "toAdics",
    "constructAdicsPoly",
    "inputFunctionCheck",
    "toPositiveRep",
    "truncatePadics",
    "Prime",

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
    "oneSeries",

    -- P-adics
    "padics",
    "PadicSeries",
    "padicOrder",
    "primeNumber",
    "valueList",
    "minusOne",
    "PositiveCoefficients",
    

    -- PowerSeriesRings
    "PowerSeriesRing",
    "isPowerSeriesRing",
    "PowerList",
    "powerList"
}

load "./LazyPowerSeries/HelperFunctions.m2"
load "./LazyPowerSeries/LazySeriesMethods.m2"
load "./LazyPowerSeries/PadicsMethods.m2"
load "./LazyPowerSeries/BasicOperations.m2"
load "./LazyPowerSeries/PowerSeriesRings.m2"


--DOCUMENTATION
beginDocumentation()
load "./LazyPowerSeries/Documentation/LazySeriesMethodsDoc.m2"
load "./LazyPowerSeries/Documentation/PadicsMethodsDoc.m2"
load "./LazyPowerSeries/Documentation/BasicOperationsDoc.m2"
load "./LazyPowerSeries/Documentation/HelperFunctionsDoc.m2"



-- TESTS
load "./LazyPowerSeries/Tests/ConstructionTests.m2"
load "./LazyPowerSeries/Tests/HelperFunctionTests.m2"
load "./LazyPowerSeries/Tests/BasicOperationsTests.m2"
load "./LazyPowerSeries/Tests/PadicsMethodsTests.m2"

end