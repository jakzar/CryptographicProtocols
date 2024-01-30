# DH 3-way
from __future__ import print_function
from sage.all import randint, next_prime, is_prime, GF

# Domain parameter generation
# INPUT:
# b - length of the characteristic of field p in bits
# OUTPUT:
# p - characteristic of field F
# n - order of the cyclic subgroup
# g - generator of the cyclic subgroup of order n
def generateParameters(b):
    p = randint(2^(b-1), 2^b)

    while True:
        p = next_prime(p)
        if p > 2^b:
            exit()
        n = (p - 1) // 2
        if is_prime(n):
            break

    F = GF(p)
    while True:
        while True:
            g = F.random_element()
            if g.multiplicative_order() == n:
                break
        if (g^n == 1):
            break

    print("Characteristic of field F: p =", p)
    print("Order of the cyclic subgroup: n =", n)
    print("Generator of the cyclic subgroup of order n: g =", g)

    return p, n, g

p, n, g = generateParameters(256)

# Key generation - public and private
# INPUT:
# p - characteristic of field F
# n - order of the cyclic subgroup
# g - generator of the cyclic subgroup of order n
# OUTPUT:
# kpriv - private key
# kpub - public key
def generateKeys(p, n, g):
    kpriv = randint(2, n-1)
    kpub = g^kpriv % p
    return kpriv, kpub

# Key generation for A, B, C
privA, pubA = generateKeys(p, n, g)
privB, pubB = generateKeys(p, n, g)
privC, pubC = generateKeys(p, n, g)

print("\nGenerated keys:")
print("Private key A: ", privA)
print("Public key A: ", pubA)
print("Private key B: ", privB)
print("Public key B: ", pubB)
print("Private key C: ", privC)
print("Public key C: ", pubC, "\n")

# Protocol
# Function raising the received value to the power equal to the private key:
# INPUT:
# priv - private key
# key - public key of the other user
# n - order of the cyclic subgroup
# OUTPUT:
# (key^priv) % p - public key raised to the private key
def protocolStep(p, key, priv):
    return (key^priv) % p
    
# Calculated values g^ab/ac/bc
B_xx = protocolStep(p, pubA, privB)
A_xx = protocolStep(p, pubC, privA)
C_xx = protocolStep(p, pubB, privC)

# K1, K2, K3
print("K1: A receives the value g^c: ", pubC, ", then calculates the value g^ac: ", A_xx)
print("K2: B receives the value g^a: ", pubA, ", then calculates the value g^ab: ", B_xx)
print("K3: C receives the value g^b: ", pubB, ", then calculates the value g^bc: ", C_xx)

# Similar operations as in K1, replacing the public key with the values calculated in K1, and passing it to the next user
C_xxx = protocolStep(p, B_xx, privC)
A_xxx = protocolStep(p, C_xx, privA)
B_xxx = protocolStep(p, A_xx, privB)

# K4, K5, K6
print("\nK4: A receives the value g^bc: ", C_xx, ", then calculates the session key value g^abc: ", A_xxx)
print("K5: B receives the value g^ac: ", A_xx, ", then calculates the session key value g^abc: ", B_xxx)
print("K6: C receives the value g^ab: ", B_xx, ", then calculates the session key value g^abc: ", C_xxx)

# K3: check if shared values are identical
print("\nChecking if shared values are equal: ")
def check(x, y, z):
    if x == y == z:
        print("Values are identical")
    else:
        print("Values are different")
        
# Call the check function
check(A_xxx, B_xxx, C_xxx)
