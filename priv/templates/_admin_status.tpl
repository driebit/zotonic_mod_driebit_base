{% if m.driebit_base_convert.needs_convert_unfindable %}
    <div class="form-group">
        <div>
            {% button class="btn btn-primary" text=_"Copy unfindable flag"
                      postback=`convert_unfindable`
                      delegate=`m_driebit_base_convert`
            %}
            <p class="help-block">
                {_ Copy the old Ginger unfindable flag over to the Zotonic resource table. After this the Ginger table holding the flags will be deleted. _}
            </p>
        </div>
    </div>
{% endif %}
