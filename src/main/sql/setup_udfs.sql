--https://www.postgresql.org/docs/10/static/plpython.html
--https://gpdb.docs.pivotal.io/43250/ref_guide/extensions/pl_python.html
CREATE EXTENSION plpython3u;

CREATE OR REPLACE FUNCTION init ()
  RETURNS integer
AS $$
 import phe.paillier as paillier, math, pickle
 pubkey, prikey = paillier.generate_paillier_keypair(n_length=1024)
 GD["pubkey"] = pubkey
 GD["prikey"] = prikey
 return 1
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION encrypt (in_value double precision)
  RETURNS bytea
AS $$
 import phe.paillier as paillier, math, pickle
 pubkey = GD["pubkey"]
 encryptedValue = pubkey.encrypt(in_value)
 pickledEncrypted = pickle.dumps(encryptedValue)
 return pickledEncrypted
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION decrypt (in_value bytea)
  RETURNS double precision
AS $$
 import phe.paillier as paillier, math, pickle
 prikey = GD["prikey"]
 encryptedValue = pickle.loads(in_value)
 decrypted = prikey.decrypt(encryptedValue)
 return decrypted
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION addition (in_value_left bytea, in_value_right bytea)
  RETURNS bytea
AS $$
 import phe.paillier as paillier, math, pickle
 value_left = pickle.loads(in_value_left)
 value_right = pickle.loads(in_value_right)
 return pickle.dumps(value_left + value_right)
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION multiplication (in_value_left bytea, in_value_right double precision)
  RETURNS bytea
AS $$
 import phe.paillier as paillier, math, pickle
 value_left = pickle.loads(in_value_left)
 return pickle.dumps(value_left * in_value_right)
$$ LANGUAGE plpython3u;