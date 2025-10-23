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

%% Creative Commons licenses and URLs
-module(m_creative_commons).

-export([
    m_get/3,

    url_for/1,
    language_url_for/2,
    label/1
]).

-include_lib("zotonic_core/include/zotonic.hrl").

-behaviour(zotonic_model).

-spec m_get( list(), zotonic_model:opt_msg(), z:context() ) -> zotonic_model:return().

% Syntax: m.creative_commons[license].url
m_get([ License, <<"url">> | Rest ], _Msg, _Context) ->
    case url_for(License) of
        undefined -> {error, enoent};
        URL -> {ok, {URL, Rest}}
    end;
% Syntax: m.creative_commons[license].language_url
m_get([ License, <<"language_url">> | Rest ], _Msg, Context) ->
    case language_url_for(License, Context) of
        undefined -> {error, enoent};
        LangUrl -> {ok, {LangUrl, Rest}}
    end;
% Syntax: m.creative_commons[license].label
m_get([ License, <<"label">> | Rest ], _Msg, _Context) ->
    case label(License) of
        undefined -> {error, enoent};
        Label -> {ok, {Label, Rest}}
    end;

% Unexpected path
m_get(_Path, _Msg, _Context) ->
    {error, unknown_path}.



%% @doc Get URL to license at the Creative Commons website
-spec url_for(binary() | string()) -> binary() | undefined.
url_for(License) when is_list(License) ->
    url_for(z_convert:to_binary(License));
url_for(<<"BY">>) ->
    <<"http://creativecommons.org/licenses/by/4.0">>;
url_for(<<"BY-SA">>) ->
    <<"http://creativecommons.org/licenses/by-sa/4.0">>;
url_for(<<"BY-ND">>) ->
    <<"http://creativecommons.org/licenses/by-nd/4.0">>;
url_for(<<"BY-NC">>) ->
    <<"http://creativecommons.org/licenses/by-nc/4.0">>;
url_for(<<"BY-NC-SA">>) ->
    <<"http://creativecommons.org/licenses/by-nc-sa/4.0">>;
url_for(<<"BY-NC-ND">>) ->
    <<"http://creativecommons.org/licenses/by-nc-nd/4.0">>;
url_for(<<"CC0">>) ->
    <<"http://creativecommons.org/publicdomain/zero/1.0">>;
url_for(<<"PD">>) ->
    <<"http://creativecommons.org/publicdomain/mark/1.0">>;
url_for(<<"CC ", License/binary>>) ->
    versioned_license(binary:split(License, <<" ">>));
url_for(<<"http://creativecommons.org/", _/binary>> = Url) ->
    url_for(label(Url));
url_for(Other) ->
    %% Values are stored as BY,SA in Ginger
    case binary:replace(Other, <<",">>, <<"-">>) of
        Replace when Replace =/= Other ->
            url_for(Replace);
        _ ->
            undefined
    end.

%% @doc Get URL to translated license at the Creative Commons website
-spec language_url_for(binary() | string() , #context{}) -> binary() | undefined.
language_url_for(License, Context) when is_list(License) ->
    language_url_for(z_convert:to_binary(License), Context);
language_url_for(License, Context) ->
    with_language(url_for(License), Context).

-spec label(binary() | string()) -> binary() | undefined.
label(URL) when is_list(URL) ->
    label(z_convert:to_binary(URL));
label(<<"https://", Url/binary>>) ->
    label(<<"http://", Url/binary>>);
label(<<"http://creativecommons.org/licenses/", Label/binary>>) ->
    label(Label);
label(<<"by/", _Version/binary>>) ->
    <<"BY">>;
label(<<"by-sa/", _Version/binary>>) ->
    <<"BY-SA">>;
label(<<"by-nd/", _Version/binary>>) ->
    <<"BY-ND">>;
label(<<"by-nc/", _Version/binary>>) ->
    <<"BY-NC">>;
label(<<"by-nc-sa/", _Version/binary>>) ->
    <<"BY-NC-SA">>;
label(<<"by-nc-nd/", _Version/binary>>) ->
    <<"BY-NC-ND">>;
label(<<"http://creativecommons.org/publicdomain/zero/", _Version/binary>>) ->
    <<"CC0">>;
label(<<"http://creativecommons.org/publicdomain/mark/", _Version/binary>>) ->
    <<"PD">>;
label(License) when is_binary(License) ->
    case z_string:to_lower(License) of
        License ->
            undefined;
        LowerLic ->
            label(LowerLic)
    end.


% Internal functions

-spec with_language(binary() | undefined, #context{}) -> binary() | undefined.
with_language(undefined, _Context) -> undefined;
with_language(Url, Context) ->
    Language = z_convert:to_binary(z_context:language(Context)),
    <<Url/binary, "/deed.", Language/binary>>.

versioned_license([<<"BY", _/binary>> = Type, Version]) ->
    <<"http://creativecommons.org/licenses/", Type/binary, "/", Version/binary>>;
versioned_license([<<"CC0">>, Version]) ->
    <<"http://creativecommons.org/publicdomain/zero/", Version/binary>>;
versioned_license([<<"PD">>, Version]) ->
    <<"http://creativecommons.org/publicdomain/mark/", Version/binary>>;
versioned_license([<<"BY", _/binary>> = Type]) ->
    <<"http://creativecommons.org/licenses/", Type/binary, "/4.0">>;
versioned_license([<<"CC0">>]) ->
    <<"http://creativecommons.org/publicdomain/zero/1.0">>;
versioned_license([<<"PD">>]) ->
    <<"http://creativecommons.org/publicdomain/mark/1.0">>;
versioned_license(_Other) ->
    undefined.
