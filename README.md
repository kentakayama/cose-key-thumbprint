# Thumbprint of COSE_Key Calculator
See draft-isobe-cose-key-thumbprint.

## Install
- `make` and `git`
- `python3` and cbor2 lib (`$ pip install cbor2`)
- `ruby` and cbor2diag tool (`$ gem install cbor`)

```
$ git clone https://github.com/kentakayama/cose_key_thumbprint.git
$ cd cose_key_thumbprint
```

## Usage
Calculating and printing COSE_Key Thumbprint:
```
$ make test                   # generate and print sha256sum
$ cbor2diag.rb ec2_p256.ckey  # print normalized COSE_Key
$ cbor2diag.rb aes128.ckey    # print normalized COSE_Key
```
or
```
$ make ec2_p256.cbor          # generate COSE_Key fron diagnostic notation
$ python3 ./calc_thumbprint_of_cose_key.py ec2_p256.cbor - -f hex
```

## How it works
```mermaid
graph TD

DN["Diagnostic Notation (*.diag)"]
CBOR["Raw COSE_Key (*.cbor)"]
CKEY["Normalized COSE_Key (*.ckey)"]
HASH["sha256sum (*.hash)"]

DN -- diag2cbor.rb --> CBOR
CBOR -- "(python3 calc_thumbprint_of_cose_key.py)" --> CKEY
CBOR -- python3 calc_thumbprint_of_cose_key.py --> HASH
```

## License and Copyright
BSD 2-Clause License

Copyright (c) 2023 SECOM CO., LTD. All Rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
