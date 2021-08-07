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
        A power series is normally described on paper in the form "a_0 + a_1x + a_2 x^2 + ...", and
        the ellipsis in the above description is implemented to maximize efficiency. By analogy
        with floating point numbers, a power series is only ever calculated to finite precision,
        but power series in this package also contain enough information to generate arbitrarily
        more precision when needed. Combined with some caching abilities, this means that
        power series whose coefficients are very difficult to compute can be manipulated
        without sacrificing the ability to calculate more terms at a later time.

        The focus is mainly on a specific type of series which we call LazySeries(Credit to Magma) which
        is a power series where all coefficients are possible to calculate by a given function. Once a
        coefficient is computed, it is stored in the object cache for fast retrieval.

        There are large documentation nodes included for @TO "Creating LazySeries"@ and
        @TO"Operations on Series"@.
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
  
     1. Creating LazySeries by the @TO2((lazySeries, Ring, Function), "HELLO HELLO")@
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


