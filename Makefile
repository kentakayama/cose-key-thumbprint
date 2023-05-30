#
# Copyright (c) 2023 SECOM CO., LTD. All Rights reserved.
#
# SPDX-License-Identifier: BSD-2-Clause
#

DIAG2CBOR := diag2cbor.rb # install this with `$ gem install cbor`
COSEKEY2THUMB := python3 ./calc_thumbprint_of_cose_key.py
TARGET := ed25519.hash ec2_p256.hash rsa2048.hash aes128.hash

.PHONY: all
all: $(TARGET)

%.cbor: %.diag
	$(DIAG2CBOR) < $< > $@

%.ckey: %.cbor
	$(COSEKEY2THUMB) $< - -f bin -k $@

.PRECIOUS: %.ckey
%.hash: %.cbor
	$(COSEKEY2THUMB) $< $@ -f bin -k $(@:.hash=.ckey)

.PHONY: ckey
ckey: $(TARGET:.hash=.ckey)

.PHONY: test
test: all
	@echo Calculated thumbprint of EdDSA Ed25519 Public key
	@echo ===Thumbprint===
	xxd -p -c 64 ed25519.hash
	@echo ================
	@echo Calculated thumbprint of EC2 P-256 Public key
	@echo ===Thumbprint===
	xxd -p -c 64 ec2_p256.hash
	@echo ================
	@echo Calculated thumbprint of AES128 Secret key
	@echo ===Thumbprint===
	xxd -p -c 64 aes128.hash
	@echo ================

.PHONY: clean
clean:
	$(RM) *.hash *.ckey
