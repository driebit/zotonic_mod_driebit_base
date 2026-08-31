%% @author Driebit <tech@driebit.nl>
%% @copyright 2026 Driebit

%% Copyright 2026 Driebit
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

-module(m_driebit_base_deployment).

-export([
    m_get/3,

    zotonic_git_version/0
]).

-include_lib("zotonic_core/include/zotonic.hrl").


m_get([ <<"zotonic_git_version">> | Rest ], _Msg, Context) ->
    case z_acl:is_admin(Context) of
        true -> {ok, {zotonic_git_version(), Rest}};
        false -> {error, eacces}
    end.

% In our deployments we don't have the `git` directory of zotonic that was used
% to perform the build, so 'm_admin_status:zotonic_git_version/0' cannot figure
% out the hash of its commit.
% However, we store this information in a custom `ZOTONIC_REF` file, so here we
% try to get that instead:
zotonic_git_version() ->
    case z_memo:get(zotonic_deployment_git_version) of
        {cached, Version} ->
            Version;
        _ ->
            DeployVersion = case file:read_file(filename:join(z_path:get_path(), "ZOTONIC_REF")) of
                {ok, Content} when is_binary(Content) ->
                    % `ZOTONIC_REF` usually contains the commit hash and message,
                    % but we only need the former:
                    case binary:split(Content, <<" ">>) of
                        [Hash | _Rest] -> Hash;
                        _ -> undefined
                    end;
                _ ->
                    undefined
            end,
            z_memo:set(zotonic_deployment_git_version, {cached, DeployVersion}),
            DeployVersion
    end.
