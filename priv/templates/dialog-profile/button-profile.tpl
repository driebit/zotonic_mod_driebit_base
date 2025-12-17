{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` or zotonic_dispatch == `logon_reset` or zotonic_dispatch == `logon_reminder` %}
    {# Do not show logon/signup link on logon and signup pages #}
{% else  %}
    {% include "dialog-profile/button-profile-live.tpl"
                target=#button_profile
                title=title|default:_"Profile"
                class=class|default:"profile--global-nav"
    %}
{% endif %}
