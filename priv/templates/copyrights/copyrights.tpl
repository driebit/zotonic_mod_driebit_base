{% if id.rights %}
    {% with m.creative_commons[id.rights].language_url as license_url %}
    <div class="copyrights">
        <span class="sr-only">{_ Copyrights _}: </span>
        {% if id.rights|upper=="BY,SA" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, this work must be licensed under an identical license if used _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="" alt="{_ Attribution _}" />
                <img src="/lib/images/icons/cc-sa.svg" class="c-copyright__icon" alt="{_ Share Alike _}" />
            </a>

        {% elif id.rights|upper=="BY,ND" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not alter, transform, or build upon this work. _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="{_ Attribution _}" />
                <img src="/lib/images/icons/cc-nd.svg" class="c-copyright__icon" alt="{_ No Derivatives _}" />
            </a>

        {% elif id.rights|upper=="BY" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_You must give the original author credit _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="{_ Attribution _}" />
            </a>

        {% elif id.rights|upper=="BY,NC,ND" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes, you may not alter, transform, or build upon this work _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="{_ Attribution _}" />
                <img src="/lib/images/icons/cc-nc.svg" class="c-copyright__icon" alt="{_ Non-commercial _}" />
                <img src="/lib/images/icons/cc-nd.svg" class="c-copyright__icon" alt="{_ No Derivatives _}" />
            </a>

        {% elif id.rights|upper=="BY,NC" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="{_ Attribution _}" />
                <img src="/lib/images/icons/cc-nc.svg" class="c-copyright__icon" alt="{_ Non-commercial _}" />
            </a>

        {% elif id.rights|upper=="BY,NC,SA" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes, this work must be licensed under an identical license if used _}">
                <img src="/lib/images/icons/cc-by.svg" class="c-copyright__icon" alt="{_ Attribution _}" />

                <img src="/lib/images/icons/cc-nc.svg" class="c-copyright__icon" alt="{_ Non-commercial _}" />
                <img src="/lib/images/icons/cc-sa.svg" class="c-copyright__icon" alt="{_ Share Alike _}" />
            </a>

        {% elif id.rights|upper=="CC0" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You may use the work freely _}">
                <img src="/lib/images/icons/cc.svg" class="c-copyright__icon" alt="{_ Public domain _}" />
            </a>

        {% elif id.rights|upper=="PD" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You may use the work freely _}">
                <img src="/lib/images/icons/cc-pd.svg" class="c-copyright__icon" alt="{_ Public domain _}" />
            </a>

        {% else %}
            <span class="caption">
                {_ All rights reserved _}
            </span>
       {% endif %}
    </div>
    {% endwith %}
{% endif %}
