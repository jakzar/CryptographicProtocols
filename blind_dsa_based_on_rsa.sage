# Protocol of blind digital signatures based on RSA
# Message m
m = randint(1, 100)
print("Message m =", m)

# Procedure for key generation
# Input:
# b - length of the number n in bits
# Output:
# (d, n) - private key
# (e, n) - public key
def RSA(b):
    if b % 2 == 1:
        b1 = b // 2
        b2 = b // 2 + 1
    else:
        b1 = b / 2
        b2 = b / 2
     
    while True:
        p = random_prime(2^b1 - 1, False, 2^(b1 - 1))
        q = random_prime(2^b2 - 1, False, 2^(b2 - 1))
        n = p * q
        if n > 2^(b - 1) and n < 2^b:
            break
    print("\nGenerating RSA keys:")
    print("p =", p)
    print("q =", q)
    print("n = pq =", n)
    
    fi = (p - 1) * (q - 1)
    while True:
        e = randint(1, fi)
        if gcd(e, fi) == 1:
            break;
            
    print("fi(n) = (p - 1)(q - 1) =", fi)
    print("1 < e < fi(n); e =", e)
    d = inverse_mod(e, fi)
    print("de = 1 (mod n); d =", d)
    
    print("\nPrivate key (d, n) = (", d, ",", n, ")")
    print("Public key (e, n) = (", e, ",", n, ")")
    return d, e, n

# Procedure implementing the steps of the protocol
# Input:
# (d, n) - private key
# (e, n) - public key
# Output:
# s - signature
def protocol(d, e, n):
    k = randint(1, n)
    print("\nProtocol steps:")
    print("K01: A randomly chooses k from the interval (1, n)")
    print("k =", k)

    t = (m * k^e) % n
    print("K02: A blinds m by calculating: t = mk^e (mod n)")
    print("t =", t)
    
    r = t^d % n
    print("K03: B signs t: r = t^d (mod n)")
    print("r =", r)
    
    s = r / k % n
    print("K04: A removes blinding from t^d by calculating: s = r / k (mod n)")
    print("s =", s)
    
    return s
   
# Procedure verifying the signature
# Input:
# (e, n) - public key
# s - signature
def verify(e, s, n):
    check = s^e % n
    print("\nVerifying the signature:\ns^e mod(n) =", check)
    print("m =", m)
    if m == check:  
        print("m == s^e mod(n) => The signature was correctly determined")
    else:
        print("m != s^e mod(n) => The signature was incorrectly determined")
    
# Calling procedures    
b = 11
d, e, n = RSA(b)
s = protocol(d, e, n)
verify(e, s, n)
