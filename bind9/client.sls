/etc/resolv.conf:
  file.managed:
    - source: salt://bind9/etc/resolv.conf
    - template: jinja


dnsmasq:
  pkg.removed: []
