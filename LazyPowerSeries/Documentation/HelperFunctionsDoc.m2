--***********************************************
--***********************************************
--Documentation for HelperFunctions.m2
--***********************************************
--***********************************************
beginDocumentation()
needsPackage "SimpleDoc";

doc ///
    Key
        (truncat, ZZ, RingElement)
        

    Headline
        Truncates a given RingElement (i.e polynomial).
    Usage
        s = truncat(n,f)
    Inputs
        n: ZZ  
        f: RingElement
    Outputs
        s: RingElement
    Description
        Example
            R = ZZ[x,y]
            f = x*y^7+ 4*x^5*y^3+65*y^5+x^3*y^2+ +x^2*y +x*y
            truncat(4, f)
            truncat(6, f)
                     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

doc ///
    Key
        (truncat, InfiniteNumber, RingElement)
        
    Headline
        Truncating case for infiniteNumber inputs.
    Usage
        s = truncat(n,f)
    Inputs
        n: InfiniteNumber  
        f: RingElement
    Outputs
        s: RingElement
    Description
        Text
            If the input is infinity then it returns the given RingElement, and
            if it is negative infinity, then it returns 0 of the ring of the RingElement. 
        Example
            R = ZZ[x,y]
            f = x*y^7+ 4*x^5*y^3+65*y^5+x^3*y^2+ +x^2*y +x*y
            truncat(infinity, f)
            truncat(-infinity, f)
                     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

doc ///
    Key
        (toMonomial, List, Ring)
        
    Headline
        Constructs a monomial using an exponent vector in the form of a List and a Ring. 
    Usage
        f = toMonomial(L,S)
    Inputs
        L: List
            that describes the exponents of the desired monomial.
        S: Ring
            in which we want the monomial to be created in.
    Outputs
        f: RingElement
            is the monomial that is constructed
    Description
        Example
            R = QQ[x,y,z]
            L = {6,43,51}
            m = toMonomial(L,R)
                  
    SeeAlso

        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

doc ///
    Key
        (maximumsList, VisibleList)
        
    Headline
        Returns an n-tuple with maximum element from each index from a list of n-tuples.
    Usage
        m = maximumsList(L)
    Inputs
        L: VisibleList
    Outputs
        m: List
            element that has maximum element for each coordinate
    Description
        Text
            Assumes that the List provided has elements of the same length.
            As an example {{a,b},{c,d},{l,m}} where #{a,b}==#{c,d}==#{l,m}==2.
        Example
            L = {{4,65,8},{2,4,6},{1,1,1},{100,2,54}}
            maximumsList(L)
     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

doc ///
    Key
        (toBinary, ZZ)
        
    Headline
        Converts integer to binary
    Usage
        b = toBinary(n)
    Inputs
        n: ZZ
    Outputs
        b: List
            element that has maximum element for each coordinate
    Description
        Example
            toBinary(432)
     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///


doc ///
    Key
        (calculatePolynomial, ZZ, Ring, Function)
    Headline
        Constructs a polynomial using the given ring and constructive function.
    Usage
        s = calculatePolynomial(n, R, f)
    Inputs
        n: ZZ  
        R: Ring
        f: Function
    Outputs
        s: RingElement
    Description
        Text
            This is used as a main mechanism behind constructing LazySeries using coefficient functions.
            Note that this requires a correct function as an input, as it checks the amount of arguments
            that the function has so that it matches the number of the generators of the ring. As an example,
            if the ring is ZZ[x,y,z] then it has 3 generators x,y,z, therefore a function like (i,j)-> i+j 
            would give an error because it only accounts for 2 arguments. 
            Note that the constructive function must have the proper amount of arguments corresponding to the
            dimension of the ring.
        Example
            R = QQ[x,y,z]
            f = (i,j,k) -> i+4*j-k
            calculatePolynomial(5,R,f)
            
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///



doc ///
    Key
        (toPositiveRep, ZZ,ZZ) 
        
    Headline
        Converts a negative number to a positive representation in mod p. 
    Usage
        b = toPositiveRep(a,n)
    Inputs
        a: ZZ
            negative number you want to convert to positive representation.
        n: ZZ
            specifies the modulus
    Outputs
        b: ZZ
    Description
        Text
            Ex: converts -1 in mod 7 to ((-1 % 7) + 7) % 7 =6
        Example
            toPositiveRep(-3,5)
     
    SeeAlso
        LazySeries
        "Creating LazySeries"
        "Operations on Series"

///

