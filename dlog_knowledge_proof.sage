# Protocol for proving knowledge of the discrete logarithm
bits = 10
# Input:
# bits - length of the characteristic p of the field Fp
# Output:
# a - generator of the multiplicative group
# b - result b=a^x(mod p)
# p - prime number
# x - secret value
def gen_parameters(bits):
    p = random_prime(2^(bits-1), 2^(bits))
    F = GF(p)
    a = F.primitive_element()
    
    while True:
        x = randint(1, p-1)
        if gcd(x, p-1) == 1:
            break
        
    b = a^x % p
    print("Generating parameters:\np =", p)
    print("\nb = a^x (mod p)")
    print("b =", b)
    print("a =", a)
    print("x =", x)
    
    return a, b, p, x

# Subsequent calls to steps
# Input:
# a - generator of the multiplicative group
# b - result b=a^x(mod p)
# p - prime number
# x - secret value
# t - number of iterations
def iterations(a, b, p, x, t):
    for i in range(0, t):
        print("\n\nIteration", i+1)
        print("\nK01: A randomly chooses r, less than p-1, and calculates h=a^r, sends h to B:")
        r = randint(1, p-1)
        h = a^r
        print("r =", r)
        print("h = a^r =", h)
    
        print("\nK02: B sends a random bit k to A")
        k = randint(0, 1)
        print("k =", k)
    
        print("\nK03: A calculates s = r+kx (mod p-1) and sends the result to B")
        s = (r + k * x) % (p - 1)
        print("s =", k)
    
        print("\nK04: B confirms that a^s=hb^k (mod p):")
        left = a^s % p
        right = h * b^k % p
        print("a^s =", left)
        print("hb^k =", right)
        if left == right:
            print("a^s=hb^k mod p => correct")
        else:
            print("a^s!=hb^k mod p => incorrect")

# Protocol
# Input:
# t - number of iterations
def protocol(t):
    a, b, p, x = gen_parameters(bits)
    iterations(a, b, p, x, t)
    
    
t = 15
protocol(t)
