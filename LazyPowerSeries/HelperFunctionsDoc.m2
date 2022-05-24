--***********************************************
--***********************************************
--Documentation for HelperFunctions.m2
--***********************************************
--***********************************************
beginDocumentation()
needsPackage "SimpleDoc";


doc ///
    Key
        (calculatePolynomial, ZZ, Ring, Function)
    Headline
        Constructs a polynomial using the given ring and constructive function that has the proper amount of arguments corresponding to the dimension of the ring.
    Usage
        s = calculatePolynomial(n, R, f)
    Inputs
        n: ZZ  
        R: Ring
    Outputs
        s: RingElement
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