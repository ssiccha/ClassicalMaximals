# Return the subgroup of <M>SL(n, p ^ e)</M> induced by the subgroup of
# <M>GL(n, p ^ e)</M> generated by <M>GL(n, p ^ f)</M> and the center
# <M>Z(GL(n, p ^ e))</M> (i.e. all scalar matrices), where <C>GF(p ^ f)</C> is
# a subfield of <C>GF(p ^ e)</C>. Note that this means <A>f</A> must be a
# divisor of <A>e</A>. We further demand that <A>p</A> be a prime number and
# that the quotient <C>f / e</C> be a prime number as well, i.e. <C>GF(p ^ e)
# </C> is a prime extension of <C>GF(p ^ f)</C>.
# Construction as in Proposition 8.1 of [2] 
BindGlobal("SubfieldSL", 
function(n, p, e, f)
    local A, B, C, D, c, k, matrixForCongruence, lambda, zeta, omega, z, X,
        result;
    if e mod f <> 0 or not IsPrimeInt(QuoInt(e, f)) then
        ErrorNoReturn("<f> must be a divisor of <e> and their quotient must be a prime but <e> = ", 
                      e, " and <f> = ", f);
    fi;

    A := SL(n, p ^ f).1;
    B := SL(n, p ^ f).2;
    zeta := PrimitiveElement(GF(p ^ e));
    k := Gcd(p ^ e - 1, n);
    c := QuoInt((k * Lcm(p ^ f - 1, QuoInt((p ^ e - 1), k))), (p ^ e - 1));
    C := zeta ^ (QuoInt(p ^ e - 1, k)) * IdentityMat(n, GF(p ^ e));

    if c = Gcd(p ^ f - 1, n) then
        result := Group(A, B, C);
        # Size according to Table 2.8 of [1]
        SetSize(result, Size(SL(n, p ^ f)) * Gcd(QuoInt(p ^ e - 1, p ^ f -
        1), n));
        return result;
    fi;

    omega := zeta ^ QuoInt(p ^ e - 1, p ^ f - 1);
    D := DiagonalMat(Concatenation([omega], List ([2..n], i -> zeta^0))) ^ c;

    # solving the congruence lambda * n = z (mod p ^ e - 1) by solving the
    # matrix equation (n, p ^ e - 1) * (lambda, t) ^ T = z over the integers
    matrixForCongruence := MatrixByEntries(Integers, 2, 1, [n, p ^ e - 1]);
    z := c * QuoInt(p ^ e - 1, p ^ f - 1);
    lambda := SolutionMat(matrixForCongruence, [z])[1];

    X := zeta ^ (-lambda) * IdentityMat(n, GF(p ^ e));
    result := Group(A, B, C, X * D);
    # Size according to Table 2.8 of [1]
    SetSize(result,
            Size(SL(n, p ^ f)) * Gcd(QuoInt(p ^ e - 1, p ^ f - 1), n)); 
    return result;
end);
