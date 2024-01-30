# DH 2 - WAY
from __future__ import print_function
from sage.all import randint, next_prime, is_prime, GF

# Domain parameter generation
# INPUT:
# b - length of the characteristic of field F in bits
# OUTPUT:
# p - characteristic of the field F
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

privA, pubA = generateKeys(p, n, g)
privB, pubB = generateKeys(p, n, g)

print("\nGenerated keys:")
print("Private key A: ", privA)
print("Public key A: ", pubA)
print("Private key B: ", privB)
print("Public key B: ", pubB)

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
A_xx = protocolStep(p, pubB, privA)

# K1, K2
print("\nK1: A receives the value g^b: ", pubB, ", then calculates the session key value g^ab: ", A_xx)
print("K2: B receives the value g^a: ", pubA, ", then calculates the session key value g^ab: ", B_xx)

# K3: check if shared values are identical
print("\nChecking if shared values are equal: ")
def check(x, y):
    if x == y:
        print("Values are identical")
    else:
        print("Values are different")
        
# Call the check function
check(A_xx, B_xx)
