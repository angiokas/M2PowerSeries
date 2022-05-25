--***********************************************
--***********************************************
--Documentation for NewPowerSeriesFunctions.m2
--***********************************************
--***********************************************
beginDocumentation()
needsPackage "SimpleDoc";

doc ///
Key
    LazySeries
    displayedPolynomial
    computedPolynomial
    ComputedDegree
    DisplayedDegree
    seriesRing



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
  
     1. Creating LazySeries by the @TO2((lazySeries, Ring, Function), "using a given ring and function")@
     2. Creating LazySeries by the @TO2((RingElement), "using a given ringElement")@
  SeeAlso
    "Operations on Series"
    
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
            This is the easiest way to make a formal power series that has coefficients inside a specifief ring.
            Make sure the function you are inputting has the same amount of inputs as the amount of variables in
            the specified ring, else it will give an error.

        Example
            R = ZZ/101[x,y];
            f = (i,j)-> i^2+4;
            s = lazySeries(R,f)
        Text
            [Additional information I want to add]
    SeeAlso
        "Creating LazySeries"
        "Operations on Series"

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
            Takes in a Ringelement (a polynomial most likely) and converts it to a LazySeries. A polynomial by definition
            is of finite degree, so we are essentially treating it now as a formal power series with infinite degree but with
            the same coefficients as before. 

        Example
            R = ZZ[x];
            f = 8*x^7+5*x^3-95*x^2+78*x+73
            lazySeries(f)

        Text
            [Additional information I want to add]
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///
---
doc ///
  Key
    "Operations on Series"
    "LazySeries + LazySeries"
    "LazySeries - LazySeries"
    "LazySeries * LazySeries"
    "LazySeries ^ ZZ"
    "LazySeries + Number"
    "LazySeries - Number"
    "LazySeries * Number"
    "Lazyseries * Ringelement"
    "LazySeries / Number"
    "LazySeries // Number"
    "Number + LazySeries"
    "Number - Lazyseries"
    "Number * LazySeries"

  Headline
    An overview of the arithmetic done on formal power series. 
  Description
   Text
        LazyPowerSeriesPackage enables a user to add and multiply LazySeries type objects.
    Example
        R = QQ[x,y]
        A = lazySeries(R,(i,j) -> i+j)
        B = lazySeries(R,(i,j)->3+i*j)
        A+B
        A-B
        A*B
        A^(-1)
        B^(-1)
    Text
        One can also interact Number type type objects with LazySeries like in the below examples.
    Example
        R = QQ[x,y]
        A = lazySeries(R,(i,j) -> i+j+1)
        n = 7
        7+A
        7*A
        A/7
        A//7
    Text
        Taking powers of LazySeries is possible using the exponentiating by squaring method, 
        also known as as double-and-add method whic huses binary conversion of a power to 
        determine the steps it needs to calculate up to a given power. This is faster than to 
        primitively multiply n times. 
    Example
        R = ZZ[x,y]
        L = lazySeries(R, (i,j)-> i+1)
        L^2
        L^10
    Text
        For inversion you can check out @TO"Inverting LazySeries"@
        
  SeeAlso
    LazySeries
    "Creating LazySeries"
    "Inverting LazySeries"

///    

doc ///
  Key
    "Inverting LazySeries"
    "LazySeries^(-1)"
    "LazySeries / LazySeries"
    "Number / LazySeries"
    "RingElement / LazySeries"
    "inverse(LazySeries)"
  Headline
    An overview of the arithmetic done on formal power series. 
  Description
   Text
        For inversion, first of all the formal power series has to be invertible
        and that can be checked if its constant term is invertible in the given
        ring. We use the formula \((1-x)^{-1} = 1+x+x^2+x^3+...\), which is
        valid with formal power series as well. The algorithm of our inversion
        function works like so (it is easier to see in one-variable case but you
        can expand it to multi0variable just as easily): First we are given a
        LazySeries L that has the form \[a_0+a_1x+a_2x^2+\cdots\]. We want to
        make it look like the initial formula we showed, therefore we take out
        the constant term and separate it from 1 to look like so:
        \[a_0(1+\frac{a_1}{a_0}x+\frac{a_2}{a_0}x^2 +\cdots)\]
        \[a_0(1-(-\frac{a_1}{a_0}x-\frac{a_2}{a_0}x^2 -\cdots))\] We can just
        denote \(g := (-\frac{a_1}{a_0}x-\frac{a_2}{a_0}x^2 -\cdots)\) and we
        have \[a_0(1-g) \] If we invert it, then
        \[(a_0(1-g))^{-1} = \frac{1}{a_0}(1+g+g^2+g^3+\cdots) \]
    Example

        
        
  SeeAlso
    LazySeries
    "Creating LazySeries"
    "Operations on Series"


///    
---

doc ///
    Key
        (isUnit, LazySeries)
    Headline
        Checks if a given LazySeries is a unit. 
    Usage
        b = isUnit(P)
    Inputs
        P: LazySeries
            that we are converting
    Outputs
        b: Boolean
    Description
        Text
            In general, a formal power series is a unit if its constant is a unit. This method checks if the constant term is invertible. 


        Example
            R = QQ[x,y]
            A = lazySeries(R,(i,j) -> i+j)
            B = lazySeries(R,(i,j) -> 3+i*j)
            isUnit(A)
            isUnit(B)

    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

doc ///
    Key
        (sub, LazySeries, Ring)
    Headline
        Promotes LazySeries defined over a ring to the specified new ring.
    Usage
        s = sub(P, R)
    Inputs
        P: LazySeries
            
        R: Ring
            that we want to promote P to.
    Outputs
        s: LazySeries
    Description
        Text
            In general, a formal power series is a unit if its constant is a unit. This method checks if the constant term is invertible. 


        Example
            R = QQ[x,y]
            P = lazySeries(R,(i,j) -> i+j)
            S = ZZ[x,y]
            sub(P,S)
            
    SeeAlso
        "Creating LazySeries"
        "Operations on Series"

///


