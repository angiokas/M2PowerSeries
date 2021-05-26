--***********************************************
--***********************************************
--Documentation for PowerSeriesFunctions.m2
--***********************************************
--***********************************************

doc ///
    Key
        toPolynomial
        (adicDigit, ZZ, ZZ, ZZ)
        (adicDigit, ZZ, ZZ, QQ)
        (adicDigit, ZZ, ZZ, List)
    Headline
        compute a digit of the non-terminating expansion of a number in the unit interval in a given base
    Usage
        d = adicDigit(p, e, x)
        D = adicDigit(p, e, L)
    Inputs
        p:ZZ
            greater than 1; the desired base
        e:ZZ
            positive, which specifies which digit is desired
        x:QQ
            in the interval [0,1]; the number whose digit is to be computed
        L:List
            consisting of rational numbers in the interval [0,1] whose digits are to be computed
    Outputs
        d:ZZ
            the {\tt e^{th}} digit of the base {\tt p} expansion of {\tt x}
        D:List
            consisting of the {\tt e^{th}} digits of the base {\tt p} expansions of the elements of {\tt L}
    Description
        Text
            The command {\tt adicDigit(p, e, 0)} returns 0.  
	    If $x$ is a rational number in the interval (0,1], then {\tt adicDigit(p, e, x)} returns the coefficient of $p^{-e}$ in
            the non-terminating base $p$ expansion of $x$.
        Example
            adicDigit(5, 4, 1/3)
        Text
            If $L$ is a list of rational numbers in the unit interval, {\tt adicDigit(p, e, L)} returns a list containing the $e^{th}$ digits (base $p$) of the elements of $L$.
        Example
            adicDigit(5, 4, {1/3, 1/7, 2/3})
    SeeAlso
        adicExpansion
        adicTruncation
///
