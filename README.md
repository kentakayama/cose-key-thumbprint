# Thumbprint of COSE_Key Calculator
See draft-isobe-cose-key-thumbprint.

## Install
- git
- Python3 and cbor2 lib (`$ pip install cbor2`)
- Ruby and cbor2diag tool (`$ gem install cbor`)

```
$ git clone https://github.com/kentakayama/cose_key_thumbprint.git
$ cd cose_key_thumbprint
```

## Usage
Calculating and printing COSE_Key Thumbprint:
```
$ make test
$ cbor2diag.rb ec2_p256.ckey
$ cbor2diag.rb aes128.ckey
```

