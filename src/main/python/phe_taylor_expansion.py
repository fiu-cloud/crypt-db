import math
import random
import phe.paillier as paillier
pubkey, prikey = paillier.generate_paillier_keypair(n_length=1024)


# time: o(n), space: o(1)
def taylorTest(exp, iterations):
    expected = math.exp(exp)
    result = 0
    for n in range(0,iterations):
        result = result + exp ** n / math.factorial(n)
    print("stdTaylorTest test pass="+ str(math.fabs(expected - result) < 0.00001))

# multiply 2 encrypted numbers using paillier
def mult(x,y):
    r1 = random.randrange(-100, 100)
    r2 = random.randrange(-100, 100)

    x_dash = x * r1
    y_dash = y * r2
    x_dash_dec = prikey.decrypt(x_dash)
    y_dash_dec = prikey.decrypt(y_dash)

    z = pubkey.encrypt(x_dash_dec * y_dash_dec)

    result = z * 1 / (r1 * r2)
    return result

# time: o(n), space: o(1)
def taylorPseudoFHETest(exp,iterations):
    expected = math.exp(exp)
    result = pubkey.encrypt(1)
    prev = result
    for n in range(1,iterations):
        current = (mult(prev, pubkey.encrypt(exp))/n)
        result += current
        prev = current
    print("taylorPseudoFHETest test pass="+ str(math.fabs(expected - prikey.decrypt(result)) < 0.00001))


taylorTest(math.pi,20)
taylorPseudoFHETest(math.pi,20)

































