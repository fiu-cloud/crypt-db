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
    actual = prikey.decrypt(result)
    print("taylorPseudoFHETest test ("+ str(iterations)+ " iterations) pass="+ str(math.fabs(expected - actual) < 0.00001))
    print("Expected "+ formatPad(expected))
    print("Actual   "+ formatPad(actual))


def formatPad(inNumber):
    if abs(inNumber) > 10e+17:
        out = ("%+.3f"%inNumber)
    else:
        out = ("%+.20f"%inNumber).zfill(40)
    return out


taylorTest(math.pi,30)
taylorPseudoFHETest(math.pi,30)

































