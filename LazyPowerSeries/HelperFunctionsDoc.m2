--***********************************************
--***********************************************
--Documentation for HelperFunctions.m2
--***********************************************
--***********************************************
beginDocumentation()
needsPackage "SimpleDoc";

doc ///
Key
    LazySeries
    LazySeries
    

Headline
    A package allowing construction and manipulation of formal power series in multi-variable.
Description
    Text     
        Formal power series are an important part of understanding ring completions. This package 
        allows the implementation of Formal Power Series which offers the usage in multi-variate
        and multi-graded rings, as well as multiplication and inversion. Of course, it is impossible
        to make an object that is infinite, however this package offers Power series in a form in which
        any coefficient can be calculated. The focus is mainly on a specific type of series which we call
        LazySeries (Credit to Magma) which is a power series where all coefficients are possible to 
        calculate by a given function, or rather a ring map. Once a coefficient is computed,
        it is stored in the object cache for fast retrieval.

        For different ways of constructing LazySeries, see @TO "Creating LazySeries"@.
        As for how to use basic operations involving LazySeries, see @TO"Operations on Series"@.
        
///

