%%% -*-mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
%%% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:
%%%
%%% Copyright 2015 Panagiotis Papadomitsos. All Rights Reserved.
%%% Copyright 2021 Miniclip. All Rights Reserved.
%%%

-module(gen_rpc_client_config).

-ignore_xref(stub/0).
-ignore_xref(behaviour_info/1).

-callback get_config(atom()) -> {tcp | ssl, inet:port_number()} | {error, term()}.

-ifdef(TEST).
%% Stub function to fool code coverage
-export([stub/0]).
stub() -> ok.
-endif.
