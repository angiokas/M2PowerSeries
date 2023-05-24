doc ///
Key
    PadicSeries

Headline
    A package allowing construction and manipulation of padic series in multi-variable rings. 
Description
    Text
    
        For different ways of constructing LazySeries, see @TO "Creating PadicSeries"@.
        As for how to use basic operations involving LazySeries, see @TO"Operations on PadicSeries"@.

    
///

doc ///
  Key
    "Creating padic integers"
    PadicSeries
    ComputedDegree
    PositiveCoefficients
    primeNumber

  Headline
    An overview of the various ways to create padic integers.
  Description
   Text
        1. 
        2. 
        3. 
     
     
    SeeAlso
        "Operations on PadicSeries"
    
///   

doc /// 
    Key
        (padics, ZZ, Ring, Function)
    Headline
        Create a PadicSeries from a specified Ring and a Function.
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
    "Operations on PadicSeries"
    "PadicSeries + PadicSeries"
    "PadicSeries - PadicSeries"
    "PadicSeries * PadicSeries"
    "PadicSeries ^ ZZ"
    "PadicSeries * Number"
    "PadicSeries + Number"
    "PadicSeries - Number"
    "Number - PadicSeries"
    "PadicSeries + RingElement"
    "PadicSeries - RingElement"
    "PadicSeries * RingElement"

Headline
    A package allowing construction and manipulation of padic series in multi-variable rings. 
Description
    Text
    
        For different ways of constructing LazySeries, see @TO "Creating PadicSeries"@.
        As for how to use basic operations involving LazySeries, see @TO"Operations on PadicSeries"@.
    Example
        R = ZZ
        A = padics(5,R, i-> 2)
        B = padics(5,R, i->1)
        A+B
        A-B
        A*B

        A-1
        A*2


        
///

doc ///
  Key
    "Inverting PadicSeries"
    "PadicSeries^(-1)"
    "PadicSeries / PadicSeries"
    "Number / PadicSeries"
    "RingElement / PadicSeries"
    "inverse(PadicSeries)"
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
        R = ZZ
        A = padics(5,R, i-> 2)
        B = padics(5,R, i->1)
        inverse(A)
        B^(-1)
        A/B
        4/A
        (x+5)/B

        
  SeeAlso
    PadicSeries
    "Creating PadicSeries"
    "Operations on PadicSeries"


///    