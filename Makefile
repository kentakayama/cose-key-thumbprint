#
# Copyright (c) 2023 SECOM CO., LTD. All Rights reserved.
#
# SPDX-License-Identifier: BSD-2-Clause
#

DIAG2CBOR := diag2cbor.rb # install this with `$ gem install cbor`
COSEKEY2THUMB := python3 ./calc_thumbprint_of_cose_key.py

.PHONY: all
all: ec2_p256.hash aes128.hash

%.cbor: %.diag
	$(DIAG2CBOR) < $< > $@

.PRECIOUS: %.ckey
%.hash: %.cbor
	$(COSEKEY2THUMB) $< $@ -f bin -k $(@:.hash=.ckey)

.PHONY: test
test: ec2_p256.hash aes128.hash
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
