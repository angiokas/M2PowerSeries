--*************************************************
--*************************************************
-- 
--*************************************************
--*************************************************
newPackage(
        "LazyPowerSeries",
        Version => "2.1", 
        Date => "12/16/2024",
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

        Headline => "Implementation of formal power series in M2.",
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
    "changeComputedDegree",

 
    -- Basic Operations
    
    "zeroSeries",
    "oneSeries",

    -- P-adics
    "padics",
    "PadicSeries",
    "PositiveCoefficients",
    "padicOrder",
    "primeNumber",
    "valueList",
    
    

    -- PowerSeriesRings
    "PowerSeriesRing",
    "isPowerSeriesRing",
    "PowerList",
    "powerList",

    -- Testing
    "checkLazySeriesCache",
    "testCases"
}

--load "./LazyPowerSeries/LoadMethods.m2"
load "./LazyPowerSeries/PowerSeriesRings.m2"
load "./LazyPowerSeries/HelperFunctions.m2"
load "./LazyPowerSeries/LazySeriesMethods.m2"
load "./LazyPowerSeries/PadicsMethods.m2"
load "./LazyPowerSeries/BasicOperations.m2"
load "./LazyPowerSeries/PadicsBasicOperations.m2"


--DOCUMENTATION
--beginDocumentation()
--load "./LazyPowerSeries/Documentation/LazySeriesMethodsDoc.m2"
--load "./LazyPowerSeries/Documentation/PadicsMethodsDoc.m2"
--load "./LazyPowerSeries/Documentation/BasicOperationsDoc.m2"
--load "./LazyPowerSeries/Documentation/HelperFunctionsDoc.m2"



-- TESTS
load "./LazyPowerSeries/Tests/LoadTests.m2"
--load "./LazyPowerSeries/Tests/LazySeries/OneVarPolyRings/Construction/ZZTests.m2"
--load "./LazyPowerSeries/Tests/BasicOperationsTests.m2"
--load "./LazyPowerSeries/Tests/ConstructionTests.m2"
--load "./LazyPowerSeries/Tests/HelperFunctionTests.m2"
--load "./LazyPowerSeries/Tests/PadicsMethodsTests.m2"
--load "./LazyPowerSeries/Tests/SeriesFunctionTests.m2"


end