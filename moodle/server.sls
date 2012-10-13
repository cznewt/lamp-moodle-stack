
include:
    - php

/srv/app/moodle-{{ pillar['moodle-version'] }}/:
    file:
        - directory
        - user: root
        - group: root
        - mode: 755
        - makedirs: true

{%- if pillar['moodle-apps'] %}
{%- for app in pillar['moodle-apps'] %}
/srv/app/moodle-{{ pillar['moodle-version'] }}/sites/{{ app.name }}/data/:
    file:
        - directory
        - user: www-data
        - group: www-data
        - mode: 777
        - makedirs: true

/srv/app/moodle-{{ pillar['moodle-version'] }}/sites/{{ app.name }}/root/:
    file:
        - directory
        - user: root
        - group: root
        - mode: 755
        - makedirs: true

/srv/app/moodle-{{ pillar['moodle-version'] }}/sites/{{ app.name }}/root/config.php:
    file:
        - managed
        - source: salt://moodle/srv/moodle/sites/config.php
        - template: jinja
        - mode: 644
        - require:
            - file: /srv/app/moodle-{{ pillar['moodle-version'] }}/sites/{{ app.name }}/root/
        - defaults:
            database_engine: "{{ app['config']['database']['engine'] }}"
            database_host: "{{ app['config']['database']['host'] }}"
            database_name: "{{ app['config']['database']['name'] }}"
            database_user: "{{ app['config']['database']['user'] }}"
            database_password: "{{ app['config']['database']['password'] }}"
            filesystem_root: "/srv/app/moodle-{{ pillar['moodle-version'] }}/sites/{{ app.name }}/data"
            vhost_name: "{{ app['config']['vhost'] }}"
{%- endfor %}
{%- endif %}
