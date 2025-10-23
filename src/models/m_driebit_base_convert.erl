%% @author Driebit <tech@driebit.nl>
%% @copyright 2025 Driebit

%% Copyright 2025 Driebit
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(m_driebit_base_convert).

-export([
    m_get/3,

    event/2,

    convert_unfindable/1,
    convert_unfindable_cleanup/1
    ]).

-include_lib("zotonic_core/include/zotonic.hrl").

-define(QUERY_TIMEOUT, 60000).

m_get([<<"needs_convert_unfindable">> | Rest], _Msg, Context) ->
    case z_acl:is_admin(Context) of
        true ->
            {ok, {z_db:table_exists(pivot_ginger_search, Context), Rest}};
        false ->
            {error, eacces}
    end.

event(#postback{ message = convert_unfindable }, Context) ->
    case z_acl:is_admin(Context) of
        true ->
            case convert_unfindable(Context) of
                {ok, _} ->
                    convert_unfindable_cleanup(Context),
                    z_render:growl("Copied is_unfindable flag, dropped table", Context);
                {error, _} ->
                    z_render:growl("Missing table, nothing to do", Context)
            end;
        false ->
            z_render:growl("You need to be admin", Context)
    end.

%% @doc Copy the is_unfindable flag from the Ginger pivot table to
%% the rsc table.
convert_unfindable(Context) ->
    case z_db:table_exists(pivot_ginger_search, Context) of
        true ->
            N = z_db:q("
                update rsc r
                set is_unfindable = p.is_unfindable
                from pivot_ginger_search p
                where p.id = r.id
                  and p.is_unfindable = true
                  and r.is_unfindable = false
                ",
                [],
                Context,
                ?QUERY_TIMEOUT),
            z:flush(Context),
            {ok, N};
        false ->
            {error, enoent}
    end.


%% @doc Delete the Ginger table holding the is_unfindable table
convert_unfindable_cleanup(Context) ->
    case z_db:table_exists(pivot_ginger_search, Context) of
        true ->
            z_db:q("drop table pivot_ginger_search", Context),
            z_db:flush(Context),
            ok;
        false ->
            {error, enoent}
    end.
