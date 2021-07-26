%%% -*-mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
%%% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:
%%%
%%% Copyright 2015 Panagiotis Papadomitsos. All Rights Reserved.
%%% Copyright 2021 Miniclip. All Rights Reserved.
%%%

%%% Common Test includes
-include_lib("common_test/include/ct.hrl").
%%% Include this library's name macro
-include("app.hrl").

%%% Node definitions
-define(MASTER, 'gen_rpc_master@127.0.0.1').
-define(MASTER_PORT, 5369).
-define(SLAVE, 'gen_rpc_slave@127.0.0.1').
-define(SLAVE_PORT, 5370).
-define(FAKE_NODE, 'fake_node@1.2.3.4').
