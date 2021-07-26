# Copyright 2015 Panagiotis Papadomitsos. All Rights Reserved.
# Copyright 2021 Miniclip. All Rights Reserved.

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -euc
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

shell: shell-master
.PHONY: shell

shell-master: epmd
	@rebar3 as dev do shell --name gen_rpc_master@127.0.0.1 --config test/gen_rpc.master.config
.PHONY: shell-master

shell-slave: epmd
	@rebar3 as dev do shell --name gen_rpc_slave@127.0.0.1 --config test/gen_rpc.slave.config
.PHONY: shell-slave

version: upgrade clean compile check test edoc
.PHONY: version

upgrade: upgrade-rebar3_lint upgrade-rebar3_hex upgrade-rebar3_hank
	@rebar3 do unlock,upgrade
.PHONY: upgrade

upgrade-rebar3_lint:
	@rebar3 plugins upgrade rebar3_lint
.PHONY: upgrade-rebar3_lint

upgrade-rebar3_hex:
	@rebar3 plugins upgrade rebar3_hex
.PHONY: upgrade-rebar3_hex

upgrade-rebar3_hank:
	@rebar3 plugins upgrade rebar3_hank
.PHONY: upgrade-rebar3_hank

clean:
	@rebar3 clean -a
.PHONY: clean

compile:
	@rebar3 compile
.PHONY: compile

check: xref dialyzer elvis-rock hank
.PHONY: check

xref:
	@rebar3 as test xref
.PHONY: xref

dialyzer:
	@rebar3 as test dialyzer
.PHONY: dialyzer

elvis-rock:
	@rebar3 lint
.PHONY: elvis-rock

hank:
	@rebar3 hank
.PHONY: hank

test: eunit ct cover
.NOTPARALLEL: test
.PHONY: test

eunit:
	@rebar3 eunit
.PHONY: eunit

ct: epmd
	@rebar3 ct
.PHONY: ct

NODES ?= 3
integration: image epmd
	@export NODES=$(NODES) && cd test/integration && bash -c "./integration-tests.sh $(NODES)"
.PHONY: integration

IMAGE = $(shell docker images -q gen_rpc:integration 2> /dev/null)
image:
	@cd test/integration && docker build --rm --pull -t gen_rpc:integration .
.PHONY: image

cover:
	@rebar3 cover
.PHONY: cover

epmd:
	epmd -daemon
.PHONY: epmd

edoc:
	@rebar3 edoc
.PHONY: edoc
