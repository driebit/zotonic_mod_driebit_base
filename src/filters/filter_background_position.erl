%% @doc filter to return a css background-position based on zotonic 0.x crop_center value
-module(filter_background_position).

-export([background_position/2]).

% -include_lib("zotonic_core/include/zotonic.hrl").

-spec background_position(integer(), z:context()) -> binary().
background_position(Id, Context) ->
    case m_rsc:p(Id, <<"crop_center">>, Context) of
        undefined ->
            <<"center center">>;
        <<>> ->
            <<"center center">>;
        CropCenter ->
            get_position(Id, CropCenter, Context)
    end.

get_position(Id, CropCenter, Context) ->
    case binary:split(z_convert:to_binary(CropCenter), <<"+">>, [ global, trim_all ]) of
        [X,Y] ->
            case m_media:get(Id, Context) of
                #{
                    <<"width">> := Width,
                    <<"height">> := Height
                } when is_integer(Width), is_integer(Height) ->
                    try
                        get_background_position(z_convert:to_integer(X), z_convert:to_integer(Y), Width, Height, Context)
                    catch _:_ ->
                        <<"center center">>
                    end;
                _ ->
                    <<"center center">>
            end;
        _ ->
            <<"center center">>
    end.

get_background_position(_X, _Y, undefined, _Height, _Context) ->
    <<"center center">>;
get_background_position(_X, _Y, _Width, undefined, _Context) ->
    <<"center center">>;
get_background_position(_X, _Y, undefined, undefined, _Context) ->
    <<"center center">>;
get_background_position(_X, _Y, 0, _Height, _Context) ->
    <<"center center">>;
get_background_position(_X, _Y, _Width, 0, _Context) ->
    <<"center center">>;
get_background_position(X, Y, Width, Height, _Context) ->
    PX = get_x(X, Width),
    PY = get_y(Y, Height),
    <<PX/binary, " ", PY/binary>>.

get_x(X, Width)->
    Percentage = (X/Width)*100,
    case Percentage < 34 of
        true ->
            <<"left">>;
        false ->
            case Percentage > 66 of
                true ->
                    <<"right">>;
                false ->
                    <<"center">>
            end
    end.
get_y(Y, Height)->
    Percentage = (Y/Height)*100,
    case Percentage < 34 of
        true ->
            <<"top">>;
        false ->
            case Percentage > 66 of
                true ->
                    <<"bottom">>;
                false ->
                    <<"center">>
            end
    end.
