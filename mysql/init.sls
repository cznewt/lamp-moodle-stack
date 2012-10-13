/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/etc/mysql/my.cnf
    - mode: 644

mysql-server-{{ pillar['mysql-version'] }}:
  pkg:
    - installed
  service.running:
   - name: mysql
   - watch:
     - file: /etc/mysql/my.cnf

{%- for db in pillar['mysql-databases'] %}
{{ db.database }}:
    mysql_database.present

{{ db.user }}:
  mysql_user.present:
    - host: localhost
    - password: {{ db.password }}

{{ db.user }}_{{ db.database }}:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ db.database }}
    - user: {{ db.user }}
{%- endfor %}
