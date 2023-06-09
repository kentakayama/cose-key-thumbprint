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
	@echo ===To Be hashed COSE_Key===
	@xxd -p -c 32 ed25519.ckey
	@echo ===Thumbprint===
	@xxd -p -c 32 ed25519.hash
	@echo ================
	@echo
	@echo Calculated thumbprint of EC2 P-256 Public key
	@echo ===To Be hashed COSE_Key===
	@xxd -p -c 32 ec2_p256.ckey
	@echo ===Thumbprint===
	@xxd -p -c 32 ec2_p256.hash
	@echo ================
	@echo
	@echo Calculated thumbprint of RSA2048 Public key
	@echo ===To Be hashed COSE_Key===
	@xxd -p -c 32 rsa2048.ckey
	@echo ===Thumbprint===
	@xxd -p -c 32 rsa2048.hash
	@echo ================
	@echo
	@echo Calculated thumbprint of AES128 Secret key
	@echo ===To Be hashed COSE_Key===
	@xxd -p -c 32 aes128.ckey
	@echo ===Thumbprint===
	@xxd -p -c 32 aes128.hash
	@echo ================

.PHONY: validate
validate: ec2_p256.hash rsa2048.hash
	@echo Validate ec2_p256.hash
	@xxd -p -c 32 ec2_p256.hash
	@xxd -p -c 32 ec2_p256.hash.validate
	@diff ec2_p256.hash.validate ec2_p256.hash || echo "[INVALID] EC2 COSE_Key Thumbprint differ" | exit 1
	@echo [VALID] EC2 COSE_Key Thumbprint matches
	@echo
	@echo Validate rsa2048.hash
	@xxd -p -c 32 rsa2048.hash
	@xxd -p -c 32 rsa2048.hash.validate
	@diff rsa2048.hash.validate rsa2048.hash || echo "[INVALID] RSA COSE_Key Thumbprint differ" | exit 1
	@echo [VALID] RSA COSE_Key Thumbprint matches
	@echo
	@echo [OK] All COSE_Key Thumbprints are valid

.PHONY: clean
clean:
	$(RM) *.hash *.ckey *.cbor
