#!/usr/bin/env python3
import sys
import hashlib
try:
    import cbor2 as cbor
except:
    print('install cbor2 with `pip install cbor2`')
    pass

def calc_thumbprint(infile: str, outfile: str, form: str, outkeyfile=None) -> None:
    """

    Parameters:
    infile (str): Input filename
    outfile (str): Output filename
    outkeyfile (str, None): COSE_Key output filename
    form (str): in ['bin', 'hex']
    """

    assert(isinstance(infile, str))
    assert(isinstance(outfile, str))
    assert(isinstance(form, str))
    assert(isinstance(outkeyfile, (str, type(None))))
    assert(form in ['bin', 'hex'])

    with open(infile, 'rb') as f:
        d = cbor.decoder.load(f)

    # extract exact key-value pairs from original COSE_Key
    # to calculate thumbprint
    if d[1] == 2: # kty == EC2
        d = dict((k, d[k]) for k in [1, -1, -2, -3]) # [kty, crv, x, y]
    elif d[1] == 3: # kty == RSA
        d = dict((k, d[k]) for k in [1, -1, -2]) # [kty, n, e]
    elif d[1] == 4: # kty == Symmetric (e.g. AES)
        d = dict((k, d[k]) for k in [1, -1]) # [kty, k]
    else:
        raise ValueError('This tool supports only EC2(kty=2), RSA(kty=3) and AES(kty=4)')

    encoded = cbor.dumps(d)

    if isinstance(outkeyfile, str):
        if form == 'bin':
            with open(outkeyfile, 'wb') as f:
                f.write(encoded)
        elif form == 'hex':
            with open(outkeyfile, 'w') as f:
                f.write(encoded.hex())

    m = hashlib.sha256()
    m.update(encoded)

    if form == 'bin':
        if outfile == '-':
            sys.stdout.buffer.write(m.digest())
        else:
            with open(outfile, 'wb') as f:
                f.write(m.digest())
    elif form == 'hex':
        if outfile == '-':
            sys.stdout.write(m.hexdigest())
        else:
            with open(outfile, 'w') as f:
                f.write(m.hexdigest())

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Convert COSE_Key to thumbprint')
    parser.add_argument('infile',
                        help='Input COSE_Key file (cbor only).')
    parser.add_argument('outthumbfile',
                        help='Output SHA256 thumbprint. (stdout if \'-\' is specified')
    parser.add_argument('-f', '--format',
                        default='bin',
                        choices=['bin', 'hex'],
                        help='Type of output. \'bin\' (default) or \'hex\'')
    parser.add_argument('-k', '--outkeyfile',
                        default=None,
                        help='Output COSE_Key file.')

    args = parser.parse_args()

    calc_thumbprint(args.infile, args.outthumbfile, args.format, args.outkeyfile)
