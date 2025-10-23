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

-module(mod_driebit_base).
-author("Driebit <tech@driebit.nl>").

-mod_title("Driebit base module").
-mod_description("Ported from mod_ginger_base.").
-mod_prio(200).
-mod_schema(1).
-mod_depends([acl]).

-include_lib("zotonic_core/include/zotonic.hrl").

-export([
    manage_schema/2,
    manage_data/2
]).

%% @doc When ACL is enabled, create a default user in the editors group
manage_schema(_Version, _Context) ->
    #datamodel{
        categories = [
            {agenda, query, [
                {title,
                    {trans, [
                        {nl, <<"Agenda">>},
                        {en, <<"Agenda">>}
                    ]}},
                {language, [en, nl]}
            ]},
            {location_query, query, [
                {title,
                    {trans, [
                        {nl, <<"Locatie zoekopdracht">>},
                        {en, <<"Location search query">>}
                    ]}},
                {language, [en, nl]}
            ]}
        ],
        resources = [
            {editor_dev, person, [
                {title, "Redacteur"},
                {name_first, "Redacteur"},
                {email, "redactie@ginger.nl"}
            ]},
            {fallback, image, [
                {title, "Fallback image"}
            ]},
            {footer_menu, menu, [
                {title, "Footer menu"}
            ]},
            {home, collection, [
                {title, "Homepage"}
            ]},
            {page_404, text, [
                {title,
                    {trans, [
                        {nl, <<"404, Deze pagina bestaat niet">>},
                        {en, <<"404, This page does not exist">>}
                    ]}},
                {language, [en, nl]},
                {is_unfindable, true},
                {seo_noindex, true}
            ]}
        ],
        predicates = [
            {subnavigation,
                [
                    {title,
                        {trans, [
                            {nl, <<"Subnavigatie">>},
                            {en, <<"Subnavigation">>}
                        ]}},
                    {language, [en, nl]}
                ],
                [
                    {content_group, collection}
                ]},
            {hasbanner,
                [
                    {title,
                        {trans, [
                            {nl, <<"Banner">>},
                            {en, <<"Banner">>}
                        ]}},
                    {language, [en, nl]}
                ],
                [
                    {content_group, image},
                    {collection, image},
                    {query, image}
                ]},
            {header,
                [
                    {title,
                        {trans, [
                            {nl, <<"Header">>},
                            {en, <<"Header">>}
                        ]}},
                    {language, [en, nl]}
                ],
                [
                    {content_group, media}
                ]},
            {hasicon,
                [
                    {title,
                        {trans, [
                            {nl, <<"Icoon">>},
                            {en, <<"Icon">>}
                        ]}},
                    {language, [en, nl]}
                ],
                [
                    {category, image}
                ]},
            {rsvp,
                [
                    {title,
                        {trans, [
                            {nl, <<"RSVP">>},
                            {en, <<"RSVP">>}
                        ]}},
                    {language, [en, nl]}
                ],
                [
                    {person, event}
                ]}
        ],
        edges = [
            {editor_dev, hasusergroup, acl_user_group_editors}
        ]
    }.

manage_data(_, Context) ->
    %% Anonymous can view everything
    Rules = [
        {rsc, [
            {acl_user_group_id, acl_user_group_anonymous},
            {actions, [view]}
        ]},
        %% Members can edit their own profile.
        {rsc, [
            {acl_user_group_id, acl_user_group_members},
            {actions, [update, link]},
            {category_id, person},
            {is_owner, true}
        ]},
        %% Members can upload media, for instance a profile picture.
        {rsc, [
            {acl_user_group_id, acl_user_group_members},
            {actions, [insert]},
            {category_id, media}
        ]},
        {rsc, [
            {acl_user_group_id, acl_user_group_members},
            {actions, [update, delete]},
            {category_id, media},
            {is_owner, true}
        ]},
        %% Editors can edit everything, including resources created by other editors
        {rsc, [
            {acl_user_group_id, acl_user_group_editors},
            {actions, [view, insert, update, delete, link]}
        ]},
        %% Editors can access the admin
        {module, [
            {acl_user_group_id, acl_user_group_editors},
            {actions, [use]},
            {module, mod_admin}
        ]},
        %% Editors can configure the menu
        {module, [
            {acl_user_group_id, acl_user_group_editors},
            {actions, [use]},
            {module, mod_menu}
        ]}
    ],
    m_acl_rule:replace_managed(Rules, ?MODULE, Context),
    m_identity:ensure_username_pw(editor_dev, "redacteur", Context).
