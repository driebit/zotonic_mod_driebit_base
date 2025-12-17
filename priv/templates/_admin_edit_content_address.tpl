{% overrules %}

{# This is a copy of admin widget template from mod_ginger_base. All the fields are as per the zotonic0 site #}

{% block address_links %}
    <div class="col-lg-6 col-md-6">
        <div class="form-group address_facebook label-floating">
            <input class="form-control" id="facebook" type="text" inputmode="url" name="facebook" value="{{ id.facebook }}" placeholder="{_ Facebook URL _}">
            <label class="control-label" for="facebook">{_ Facebook URL _}</label>
        </div>
    </div>
    <div class="col-lg-6 col-md-6">
        <div class="form-group address_linkedin label-floating">
            <input class="form-control" id="linkedin" type="text" inputmode="url" name="linkedin" value="{{ id.linkedin }}" placeholder="{_ LinkedIn URL _}">
            <label class="control-label" for="linkedin">{_ LinkedIn URL _}</label>
        </div>
    </div>
    {# Should we support X? (aka Twitter)
        <div class="form-group address_twitter label-floating">
            <input class="form-control" id="twitter" type="text" inputmode="url" name="twitter" value="{{ id.twitter }}" placeholder="{_ Twitter URL _}">
            <label class="control-label" for="twitter">{_ Twitter URL _}</label>
        </div>
    #}
{% endblock %}
