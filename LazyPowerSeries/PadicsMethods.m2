--*******************************************************
--Implementation of P-ADICS
--*******************************************************

padicOrder = method()
padicOrder(ZZ, RingElement) := ZZ => (p, f) ->(
    if (f==0) then return -infinity;
    p = sub(p,ring f);
    i := 0;
    tempf := sub(0,ring f);
    while(tempf == 0) do (
        i = i+1;
        tempf = f % ideal (p^i);
    );
    return i-1;

);



Padics = new Type of LazySeries; -- Could potentially change it to HashTable since so far have not used inheritence

net Padics := L -> (
    myStr := net("");
    local tempStr;
    local tempTerm;
    local tempCoefficient;
    local k;
    p := L.primeNumber;

    valueList := L.cache.valueList;
    termList := keys valueList;
    coefficientList := values valueList;

    j :=0;

    while (j< #termList) do (
        tempCoefficient= toString(coefficientList#j);
        if(tempCoefficient != "0") then(
            
            tempStr = toString(termList#j);
            if (tempStr#0 === "-") then (
                tempTerm = (-1)*(termList#j);
                if (j > 0) then myStr = myStr | net(" - ");
                if (j == 0) then myStr = net("-");
            )
            else (
                if (j > 0 and myStr != "") then myStr = myStr | net(" + ");
                tempTerm = termList#j;
            );

            k = padicOrder(p,sub(tempTerm,L.seriesRing)); -- add if else so that removes when k =0
            
            if(k == 0) then(
                tempTerm = net((entries monomials(tempTerm))#0#0);
                myStr = myStr |net (tempCoefficient)| net("*") | net (tempTerm);
                )
            else if(k ==1) then(
                tempTerm = net(p) | net("*") | net((entries monomials(tempTerm))#0#0);
                myStr = myStr |net (tempCoefficient)| net("*") | net (tempTerm);

            )
            else (
                tempTerm = net(p) | net("^") | net(k) | net("*") | net((entries monomials(tempTerm))#0#0);
                myStr = myStr |net (tempCoefficient)| net("*") | net (tempTerm);
            );      
        );

        j = j+1;        
    );  

    net(myStr | net(" + ... "))

    );

toString Padics := L -> (
    myStr := net("");
    local tempStr;
    local tempTerm;
    local tempCoefficient;
    local k;
    p := L.primeNumber;

    valueList := L.cache.valueList;
    termList := keys valueList;
    coefficientList := values valueList;

    j :=0;
    while (j< #termList) do (
        tempCoefficient= toString(coefficientList#j);
        if(tempCoefficient != "0") then(
            
            tempStr = toString(termList#j);
            if (tempStr#0 === "-") then (
                tempTerm = (-1)*(termList#j);
                if (j > 0) then myStr = myStr | net(" - ");
                if (j == 0) then myStr = net("-");
            )
            else (
                if (j > 0 and myStr != "") then myStr = myStr | net(" + ");
                tempTerm = termList#j;
            );

            k = padicOrder(p,sub(tempTerm,L.seriesRing)); -- add if else so that removes when k =0
            
            if(k == 0) then(
                tempTerm = net((entries monomials(tempTerm))#0#0);
                myStr = myStr |toString (tempCoefficient)| net("*") | net (tempTerm);
                )
            else if(k ==1) then(
                tempTerm = net(p) | net("*") | net((entries monomials(tempTerm))#0#0);
                myStr = myStr |toString (tempCoefficient)| net("*") | net (tempTerm);

            )
            else (
                tempTerm = net(p) | net("^") | net(k) | net("*") | net((entries monomials(tempTerm))#0#0);
                myStr = myStr |toString (tempCoefficient)| net("*") | net (tempTerm);
            );      
        );

        j = j+1;        
    );    

    toString(myStr | toString(" + ... "))
);
----------------------PADICS CONSTRUCTORS-----------------------------------------------------------------

padics = method(Options => {Degree => 6, DisplayedDegree => 10, ComputedDegree => 10})

-- Constructs Padics over the given ring R using inputted coefficient function f 
padics(Ring, ZZ, Function) := Padics => opts -> (R, p, f) -> ( 

    computedPoly := constructAdicsPoly(R, p, f);
    displayedPoly := truncat(opts.DisplayedDegree, computedPoly); -- Truncating could be different since users might want to treat degree with variables p, x_1,...,x_n

    new Padics from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            valueList => toAdics(p, computedPoly)
        }
    }
);

--converts polynomials to Padics
padics(ZZ, RingElement) := Padics => opts -> (p, g) -> ( 
    R := ring g; 
    f := v -> coefficient(v, g);

    --deg:= infinity; -- default degree, it should be infinite unless the user says
    --if not (opts.DisplayedDegree === null) then deg = opts.DisplayedDegree;
      
    padics(
        p,
        f,
        g,
        DisplayedDegree => opts.DisplayedDegree,
        ComputedDegree => infinity
        ) 
);

-- Making a Padics without the added computation of polynomial construction
padics(ZZ, Function, RingElement) := LazySeries => opts -> (p, f, computedPoly) -> ( 
    R := ring computedPoly;

    new Padics from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => truncat(opts.DisplayedDegree, computedPoly),
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            valueList => toAdics(p, computedPoly)
        }
    }
);

-*
padics(Ring, ZZ, List) := Padics => opts -> (R, p, L) -> (
    variables := vars(gens R +1);
    f := variables -> coefficient()


    new Padics from {
        coefficientFunction => f,
        seriesRing => R,
        primeNumber => p,

        cache => new CacheTable from { -- contains everything mutable
            DisplayedDegree => opts.DisplayedDegree,
            displayedPolynomial => displayedPoly,
            ComputedDegree => opts.ComputedDegree,
            computedPolynomial => computedPoly,
            valueList => L
        }
    }

)
*-


-- Coefficient function overload for p-adics
coefficient(VisibleList, Padics) := (L, M) -> (
    R := M.seriesRing;
    p := M.primeNumber;
    variables := {sub(p, R)} | toList gens R;
    monomial := product(apply(#variables, i->(variables#i)^(L#i)));
    H := M.cache.valueList;

    H#monomial
);