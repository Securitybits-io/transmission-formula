#Package.transmission init.sls
{% set transmission = pillar['transmission'] %}

# Install package
install transmission:
  pkg.installed:
    - name: transmission-daemon

{% if salt['pillar.get']('transmission:config') %}
stop transmission:
  service.dead:
    - name: transmission-daemon
    - require:
      - pkg: install transmission

configure transmission:
  file.managed:
    - name: /var/lib/transmission-daemon/info/settings.json
    - contents_pillar: transmission:config
    - user: root
    - group: root
    - mode: 777
    - require:
      - stop transmission
      - pkg: install transmission
{% endif %}

#Enable Package
transmission enabled:
  service.running:
    - name: transmission-daemon
    - restart: {{ transmission['restart'] | default(True) }}
    - enable: {{ transmission['enable'] | default(True) }}
    - watch:
      - file: /var/lib/transmission-daemon/info/settings.json
