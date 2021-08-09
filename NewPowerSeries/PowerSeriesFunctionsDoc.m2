--***********************************************
--***********************************************
--Documentation for NewPowerSeriesFunctions.m2
--***********************************************
--***********************************************
beginDocumentation()
needsPackage "SimpleDoc";

doc ///
Key
    NewPowerSeries
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

doc ///
  Key
    "Creating LazySeries"
    lazySeries
  Headline
    An overview of the various ways to create LazySeries.
  Description
   Text
     Most series have enough information to extend their polynomial approximation to 
     arbitrary degree when needed. This means that even though sums and products of
     series will return finite-precision results, the precision can be increased at
     any time. The easiest examples of such series are:
  
     1. Creating LazySeries by the @TO2((lazySeries, Ring, Function), "hjghj")@
  SeeAlso
    hilbertSeries
///    

doc /// 
    Key
        (lazySeries, Ring, Function)
    Headline
        Create a LazySeries from a specified Ring and a Function.
    Usage
        s = lazySeries(R, f)
    Inputs
        R: Ring
            specified ring
        f: Function
            is the function which has to have the same amount of inputs as the variables of R
    Outputs
        s: LazySeries
    Description
        Text
            [ENTER DESCRIPTION]

        Example
            R = ZZ/101[x,y];
            f = (i,j)-> i^2+4;
            s = lazySeries(R,f)
        Text
            [Additional information I want to add]
    SeeAlso
        "Creating LazySeries"

///

doc ///
    Key
        (lazySeries, RingElement)
    Headline
        Converts RingElement into LazySeries. 
    Usage
        s = lazySeries(P)
    Inputs
        P: RingElement
            that we are converting
    Outputs
        s: LazySeries
    Description
        Text
            [ENTER DESCRIPTION]

        Example
            R = ZZ/101[x,y];
            f = (i,j)-> i^2+4;
            s = lazySeries(R,f)
        Text
            [Additional information I want to add]
    SeeAlso
        "Creating LazySeries"

///


