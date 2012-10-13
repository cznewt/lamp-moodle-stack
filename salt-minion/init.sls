/etc/salt/minion:
    file:
        - managed
        - source: salt://salt-minion/etc/salt/minion
        - user: root
        - group: root
        - template: jinja
        - defaults:
            {%- if pillar['postgresql-server'] %}
            postgresql_server: True
            {% else %}
            postgresql_server: False
            {%- endif %}
            salt_master: pillar['salt-master']
