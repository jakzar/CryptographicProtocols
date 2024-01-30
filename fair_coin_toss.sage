# Fair coin tossing protocol

# Function generating a prime number p=3(mod4)
# Input:
# b - length of the number in bits
# Output:
# p - prime number
def genPrime(b):
    p = randint(2^(b-1), 2^b)

    while True:
        p = next_prime(p)
        if p > 2^b:
            exit()
    
        if p % 4 == 3:
            break
    return p

# Function determining Blum's number
# Input:
# b1, b2 - lengths of prime numbers in bits
# Output:
# n - Blum's number
# p, q - prime numbers
def genBlum(b1, b2):
    p = genPrime(b1)
    q = genPrime(b2)   
    n = p * q
    
    return n, p, q
           
# Function implementing the steps of the coin tossing protocol
# Input:
# b1, b2 - lengths of prime numbers in bits
def protocol(b1, b2):
    
    # Calling the function generating Blum's number
    n, p, q = genBlum(b1, b2)
    
    # Determining the number x, gcd(x, n)=1
    x = randint(2, n)
    while True:
        if gcd(x, n) == 1:
            break
        else:
            x = randint(2, n)
            
    print("K1: A generates the Blum integer n (including prime numbers p and q) and the number x coprime with n:")
    print("n =", n)
    print("p =", p)
    print("q =", q)
    print("x =", x)
        
    # Calculating x0=x^2 mod n and x1=x0^2 mod n
    x0 = mod(x^2, n) 
    x1 = mod(x0^2, n)
    
    print("\nK2: A calculates x0=x^2 (mod n) and x1=x0^2 (mod n); sends to B numbers n and x1:")
    print("x0 =", x0)
    print("x1 =", x1)
    
    print("\nK3: B guesses whether x0 is even or odd:")
    # Guessing whether x0 is even, 1 - odd, 0 - even
    guess = randint(0, 1)
    print("guess =", guess)
    if guess == 0:
        print("B guesses that x0 is even")
    else:
        print("B guesses that x0 is odd")
    
    
    print("\nK4: A sends x and x0 to B")
    print("x =", x)
    print("x0 =", x0)
    
    
    print("\nK5a: B checks whether n is a Blum number (based on p and q received from A):")
    
    # Calculating p and q mod 4 and checking if they match 3
    test1 = mod(p, 4)
    test2 = mod(q, 4)
    
    if test1 == 3 and test2 == 3 and n == p * q:
        print("p mod 4 =", test1, "\nq mod 4 =", test2, "\nNumber n is a Blum number")
    else:
        print("p mod 4 =", test1, "q mod 4 =", test2, "\nNumber n is not a Blum number")
        exit()
    
    # Checking whether x0=x^2 mod n and x1=x0^2 mod n
    print("\nK5b: B checks whether x0=x^2 mod n and x1=x0^2 mod n:")
    test3 = mod(x^2, n)
    test4 = mod(x0^2, n)
    
    if test3 == x0 and test4 == x1:
        print("x^2 mod n =", test3, "\tx0 =", x0, "\nx0^2 mod n =", test4, "\tx1 =", x1, "\nNumbers are equal, everything is correct")
    else:
        print("x^2 mod n =", test3, "\tx0 =", x0, "\nx0^2 mod n =", test4, "\tx1 =", x1, "\nNumbers are not equal, an error occurred")
        exit()
        
    # Calculating whether the number is even or odd    
    parity = mod(x0, 2)
    
    # Determining the result HEAD or TAIL based on correctly guessing parity
    if parity == 0:
        print("\nK5c: Number x0 is even:")
    else:
        print("\nK5c: Number x0 is odd:")
    
    if parity == guess:
        print("B correctly guessed the parity of the number, the result is HEAD")
    else:
        print("B incorrectly guessed the parity of the number, the result is TAIL")

# Input parameters        
b1 = 100
b2 = 100
# Calling the protocol with input parameters
protocol(b1, b2)
