%% @doc filter to return a css background-position based on zotonic 0.x crop_center value
-module(filter_background_position).

-export([background_position/2]).

-spec background_position(integer(), z:context()) -> binary().
background_position(Id, Context) ->
    case m_rsc:p(Id, <<"medium_edit_settings">>, Context) of
        #{
            % <<"crop_center_x">> := X,
            % <<"crop_center_y">> := Y
        } ->
            % Cropping is done by the image resize routines, so we
            % can center the image.
            <<"center center">>;
        _ ->
            case m_rsc:p(Id, <<"crop_center">>, Context) of
                undefined ->
                    <<"center center">>;
                <<>> ->
                    <<"center center">>;
                CropCenter ->
                    get_position(Id, CropCenter, Context)
            end
    end.

get_position(Id, CropCenter, Context) ->
    case binary:split(z_convert:to_binary(CropCenter), <<"+">>, [ global, trim_all ]) of
        [X,Y] ->
            case m_media:get(Id, Context) of
                #{
                    <<"width">> := Width,
                    <<"height">> := Height
                } when is_number(Width), is_number(Height) ->
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

get_background_position(X, Y, Width, Height, _Context) ->
    PX = get_x(X, Width),
    PY = get_y(Y, Height),
    <<PX/binary, " ", PY/binary>>.

get_x(_X, 0)-> <<"center">>;
get_x(X, Width)-> get_xp(X/Width).

get_xp(Percentage) when Percentage < 0.34 -> <<"left">>;
get_xp(Percentage) when Percentage > 0.66 -> <<"right">>;
get_xp(_) -> <<"center">>.

get_y(_Y, 0) -> <<"center">>;
get_y(Y, Height)-> get_yp(Y/Height).

get_yp(Percentage) when Percentage < 0.34 -> <<"top">>;
get_yp(Percentage) when Percentage > 0.66 -> <<"bottom">>;
get_yp(_) -> <<"center">>.

