# Undeniable signature 

# Function generating a field
# Input:
# b - field size in bits
# Output:
# F - field
# p - prime number
# g - primitive element
def genPrime(b):
    p = random_prime(2^b - 1, false, 2^(b-1))
    print("\nAssumptions:\nRandom prime number:\np =", p)
    F = GF(p)
    g = F.primitive_element()
    print("\nPrimitive element:\ng =", g)
    return F, p, g

# Function generating keys
# Input:
# p - prime number
# g - primitive element
# Output:
# x - private key
# X - public key
def genKeys(p, g):
    # Generation of the private key x
    x = randint(1, p-1)
    while True:
        if gcd(x, (p-1)) == 1:
            break
        else:
            x = randint(1, p-1)
    print("\nGenerated private key:")
    print("x =", x)

    # Generation of the public key X
    X = g^x
    print("\nGenerated public key:")
    print("X =", X)
    return x, X

# Function generating a signature
# Input:
# F - field
# m - secret
# x - private key
# Output:
# z - signature
def genSignature(F, m, x):
    # Generation of the signature z
    z = F(m^x)
    print("\nGENERATING SIGNATURE:\nK01: Signer A generates a signature z for the message m")
    print("z =", z)
    return z

# Function verifying the signature
# Input:
# F - field
# p - prime number
# g - primitive element
# m - secret
# x - private key
# X - public key
# z - signature
def verifySignature(F, p, g, m, x, X, z):
    # Randomly choosing numbers a and b
    a = randint(1, p-1)
    b = randint(1, p-1)
    # Calculating the value c
    c = F(m^a * g^b)
    print("\nVERIFYING SIGNATURE:\nK01a: User B chooses random a and b (a, b < p):")
    print("a =", a, "\nb =", b)
    print("K01b: then sends the result c=F(m^a*g^b) to A:")
    print("c =", c)

    # Randomly choosing the value q
    q = randint(1, p-1)
    print("K02a: User A randomly chooses a number q smaller than p:")
    print("q =", q)
    
    # Calculating the values s1, s2
    s1 = F(c * g^q)
    s2 = F((c * g^q)^x)
    print("K02b: User A sends to B the results s1=cg^q (mod p) and s2=(cg^q)^x (mod p):")
    print("s1 =", s1, "\ns2 =", s2)

    print("K03: User B sends values a and b to user A")
    
    # Calculating the values s1_p, s2_p
    s1_p = F(c * g^q)
    s2_p = F(X^(b+q) * z^a)
    print("K04a: User A sends q to B")
    print("K04b: User B calculates the values s1_p=cg^q and s2_p=X^(b+q)*z^a")
    print("s1_p =", s1_p, "\ns2_p =", s2_p)
    
    # Checking the equality of s1, s2 with s1_p, s2_p and at the same time verifying the signature
    if(s1 == s1_p and s2 == s2_p):
        print("K05: s1==s1_p and s2==s2_p - the signature is valid")
    else:
        print("K05: s1!=s1_p and s2!=s2_p - the signature is not valid")

# Function calling individual protocol steps
# Input:
# m - secret
# b- field size in bits
def protocol(b, m):
    F, p, g = genPrime(b)
    x, X = genKeys(p, g)
    z = genSignature(F, m, x)
    verifySignature(F, p, g, m, x, X, z)

# Input parameters
# m - secret
# b- field size in bits
m = randint(1, 1000)
print("Secret m =", m)

b = 20
print("Field size b =", b)

# Calling the protocol with input parameters
protocol(b, m)
