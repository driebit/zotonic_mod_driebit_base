
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>
        {% block title %}
            {% if id %}
                {{ id.seo_title|default:id.title ++ " - " ++ m.site.title }}
            {% else %}
                {{ m.site.title }}
            {% endif %}
        {% endblock %}
    </title>

    {% include "head/favicon.tpl" %}

    {% lib
        "bootstrap/css/bootstrap.min.css"
    %}

    {% lib
        "css/z.icons.css"
        "css/logon.css"
        "css/screen.css"
    %}

    {% block canonical %}{% endblock %}

    {% all include "_html_head.tpl" %}
</head>
