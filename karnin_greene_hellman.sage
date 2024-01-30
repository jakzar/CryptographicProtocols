# Karnin-Greene-Hellman scheme
# Parameters:
# q - prime number
# m - parameter
# k - parameter
# n - parameter
# alpha - primitive element
# M - secret for splitting
q = random_prime(2^10-1, false, 2^(10-1))
m = 10
n = 17
k = 8
# Field Fq^m
G.<a> = GF(q^m)
alpha = G.primitive_element()

print("Initial parameters:")
print("q =", q)
print("m =", m)
print("n =", n)
print("k =", k)
print("alpha =", alpha)

# M - secret, as an element of the field Fq^m
M = G.random_element()
print("M =", M)

# Generating shadows
def genShadows():
    a = []
    # Trusted party chooses elements a1, a2, ..., ak-1 from the field Fq^m
    for i in range(0, k-1):
        a.append(G.random_element())
    
    print("\nK1 - Trusted party: Determining elements a1, a2, ..., ak-1: ")
    for i in range(0, k-1):
        print("a[", i+1, "]:", a[i])

    # Trusted party determines n shadows by multiplying the appropriate matrices:
    # Generated auxiliary matrix A
    A = zero_matrix(G, n, k)
    for i in range(0, A.nrows()):
        if i == A.nrows() - 1:
            for j in range(0, A.ncols()):
                if j == A.ncols() - 1:
                    A[i, j] = 1
                else:
                    A[i, j] = 0
        else:
            for j in range(0, A.ncols()):
                A[i, j] = (alpha^(i+1))^j
            
    print("\nK2a - Trusted party: Auxiliary matrix A:")
    print(A)
    
    # Matrix B with dimensions k x 1 with the message
    B = zero_matrix(G, k, 1)
    for i in range(0, B.nrows() - 1):
        B[i+1, 0] = a[i]
 
    B[0, 0] = M
    
    print("\nK2b - Trusted party: Matrix B with the message:")
    print(B)

    # Determining shadow matrices by the trusted party
    C = zero_matrix(G, n, 1)
    C = A * B
    print("\nK2c - Trusted party: Determined shadow matrix to be sent to participants: ")
    print(C)
    
    return C 
C = genShadows()

# Reconstruction of the secret
def reconstruct(C):
    # Participants i1, i2, ik determine matrix D
    if k == n:
        D = zero_matrix(G, k, k)
        for i in range(0, D.nrows()):
            if i == D.nrows() - 1:
                for j in range(0, D.ncols()):
                    if j == D.ncols() - 1:
                        D[i, j] = 1
                    else:
                        D[i, j] = 0
            else:    
                for j in range(0, D.ncols()):
                    D[i, j] = (alpha^(i+1))^j
    else:
        D = zero_matrix(G, k, k)
        for i in range(0, D.nrows()):
            for j in range(0, D.ncols()):
                D[i, j] = (alpha^(i+1))^j
    
    print("\nK4 - Participants: participants i1, i2, ..., ik determined matrix D: ")
    print(D)    

    # Inversion of matrix D
    Dinv = D.inverse()
    print("\nK5a - Participants: Inversion of matrix D:")
    print(Dinv)
    
    # Copying k rows from matrix C to matrix Ck
    Ck = zero_matrix(G, k, 1)
    for i in range(0, Ck.nrows()):
        Ck[i, 0] = C[i, 0]
    
    print("\nK5b - Participants: Auxiliary matrix Ck:")
    print(Ck)

    # Determining the secret based on k shadows
    Out = zero_matrix(G, k, 1)
    Out = Dinv * Ck
    print("\nK5c - Participants: Determined matrix with the secret by k shadows:")
    print(Out)
    return Out

secret = reconstruct(C)

# Checking if the message was recovered
if secret[0, 0] == M:
    print("\nSuccessfully determined the message")
else:
    print("\nFailed to determine the message")
