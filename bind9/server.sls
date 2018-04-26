dnsmasq:
  pkg.removed: []

{% set hostaliases = salt["pillar.get"]("placement:hostalias") %}
{% set zones=[] %}
{% for hostalias in hostaliases %}
  {% for alias,data in hostalias.items() %}
    {% set zone=".".join(alias.split(".")[1:]) %}
    {% if zone not in zones %}
      {% do zones.append(zone) %}
    {% endif %}
  {% endfor %}
{% endfor %}



bind9:
  pkg.installed: []
  service.running:
    - watch:
      - file: /etc/bind/named.conf.local
      - file: /etc/bind/named.conf.options
      {%- for zone in zones %}
      - file: /etc/bind/{{zone}}.db
      {%- endfor %}


/etc/bind/named.conf.local:
  file.managed:
    - source: salt://dns/etc/bind/named.conf.local
    - template: jinja
    - context:
        zones: {{zones}}

/etc/bind/named.conf.options:
  file.managed:
    - source: salt://dns/etc/bind/named.conf.options
    - template: jinja


{% for zone in zones %}
/etc/bind/{{zone}}.db:
  file.managed:
    - source: salt://dns/etc/bind/dns-zone.tpl
    - template: jinja
    - context:
        reccords:
          {% for hostalias in hostaliases -%}
            {%- for alias,data in hostalias.items() -%}
              {%- if ".".join(alias.split(".")[1:]) == zone -%}
              {%- set a_name = alias.split(".")[0] %}
          {{a_name}}: {{salt["mine.get"]("*","network.ip_addrs")[data["host"]][0] }}
              {%- endif %}
            {% endfor -%}
          {%- endfor %}

{% endfor %}
