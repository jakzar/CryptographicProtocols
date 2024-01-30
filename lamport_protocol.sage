#Lamport Protocol
import hashlib
import binascii

# introduction
# input parameters:
# n - number of iterations

n = 19
ptr = n

# generating identifiers:
# input:
# n - number of iterations
# y - initial value
# output:
# x[]
def generateIdentifiers(n, y):
    x = []
    x.append(y)
    print("User chose the initial value x0 =", y)

    # generating iterations using the hash function
    d = hashlib.sha3_512()
    d.update(str(x[0]).encode())
    hashValue = d.hexdigest()
    x.append(hashValue)

    for i in range(2, n + 1):
        tmp = x[i - 1]
        d = hashlib.sha3_512()
        d.update(tmp.encode())
        hashValue = d.hexdigest()
        x.append(hashValue)

    print("Generated identifier hashes:")
    for i in range(0, n + 1):
        print("x[", i, "] =", x[i])

    return x

x = generateIdentifiers(n, 100)

# protocol steps:
def protocol(k):
    # K1: user sends xk
    print("\nK1: User sends the identifier x_k:", x[k])

    # K2: system checks the existence of a user with the given identifier
    check = False
    print("K2: System checks the existence of a user with identifier x_k")
    for i in x:
        if x[k] == i:
            check = True
            print("    User with identifier x_k exists")
            print("    Please provide the password x_k-1")

    if not check:
        print("    User with identifier x_k does not exist")
        exit()

    # user provides the password xk-1
    key = x[k - 1]
    print("K3: User provides the value x_k-1 =", key)

    # calculation of the verification value
    d = hashlib.sha3_512()
    if key == x[0]:
        d.update(str(key).encode())
    else:
        d.update(key.encode())
    hashValue = d.hexdigest()
    verifyV = hashValue
    print("K4: Calculated verification value:", verifyV)

    # checking the consistency of the verification value with the identifier
    print("K5: Checking the consistency of the verification value with the identifier")
    if x[k] == verifyV:
        print("    The provided password is correct, changing the identifier during login")
    else:
        print("    The provided password is incorrect")
        exit()


for i in range(0, n):
    print("\nIteration ", i)
    protocol(ptr)
    ptr = ptr - 1
