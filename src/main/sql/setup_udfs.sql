--https://www.postgresql.org/docs/10/static/plpython.html
CREATE EXTENSION plpython3u;

CREATE OR REPLACE FUNCTION encrypt (in_value double precision)
  RETURNS bytea
AS $$
 import phe.paillier as paillier, math, pickle
 pubkey, prikey = paillier.generate_paillier_keypair(n_length=1024)
 encryptedValue = pubkey.encrypt(in_value)
 pickledEncrypted = pickle.dumps(encryptedValue)
 return pickledEncrypted
$$ LANGUAGE plpython3u;