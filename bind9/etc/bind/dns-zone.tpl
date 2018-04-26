{%- set dns_server = salt["pillar.get"]("bind:config:dns-server:host") -%}
$TTL  604800
@ 10800 IN SOA localhost. root.localhost. 1513692434 10800 3600 604800 1080
           NS ns
ns              A       {{ salt["mine.get"]("*","network.ip_addrs")[dns_server][0] }}
{% for name, ip in  reccords.items() -%}
{{name}} A {{ip}}
{% endfor -%}
