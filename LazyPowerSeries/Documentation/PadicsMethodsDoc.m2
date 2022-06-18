
doc ///
    Key
        (toAdics, ZZ, Thing)
        
    Headline
        Extracts information about the appropariate coefficients of a polynomial in p-adics form.
    Usage
        s = toAdics(p, f)
    Inputs
        p: ZZ
        f: Thing
            something promotable to a ring.
    Outputs
        s: List
    Description
        Example
            R = ZZ[x,y]
            f = 32*x^2*y+ 60*y^3+54+14*x
            toAdics(5, f)
     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///