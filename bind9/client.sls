/etc/resolv.conf:
  file.managed:
    - source: salt://dns/etc/resolv.conf
    - template: jinja


dnsmasq:
  pkg.removed: []
