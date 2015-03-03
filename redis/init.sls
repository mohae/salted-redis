# salt/dev/redis/init.sls
# Installs redis based on the pillar settings.

{% if salt['pillar.get']('redis-server:enabled') %}
{% set version = salt['pillar.get']('redis-server:version', 'redis-stable') %}
{% set work = salt['pillar.get']('redis-server:work', '/tmp/redis') %}
{% set root = salt['pillar.get']('redis-server:root', '/etc/redis') %}
{% set var = salt['pillar.get']('redis-server:var', '/etc/var') %}
{% set port = salt['pillar.get']('redis-server:port', 6379) %}
{% set checksum_info = salt['pillar.get']('redis-checksums:redis-' + version + '-checksum', {}) %}
{% set checksum = checksum_info.get('checksum', '') %}
{% set algo = checksum_info.get('algo', 'sha1') %}

redis-{{ version }}-dependencies:
  pkg.installed:
    - names:
    {% if grains['os_family'] == 'Debian' %}
      - build-essential
      - libxml2-dev
      - python-dev
    {% elif grains['os_family'] == 'RedHat' %}
      - make
      - libxml2-dev
      - python-devel
    {% endif %}

download-redis-{{ version }}:
  archive.extracted:
    - name: {{ work }}/
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    - source_hash: {{ algo }}={{ checksum }}
    - archive_format: tar
#    - tar_options: zv
    - if_missing: {{ work }}/redis-{{ version }}
    - require:
      - pkg: redis-{{ version }}-dependencies

make-redis-{{ version }}:
  cmd.wait:
    - watch:
      - archive: download-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - make

copy-redis-{{ version }}-executables:
  cmd.wait:
    - watch:
      - cmd: make-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}/src
    - names:
      - cp redis-server /usr/local/bin/
      - cp redis-cli /usr/local/bin/
      - cp redis-server /usr/local/bin/
      - cp redis-sentinel /usr/local/bin/
      - cp redis-benchmark /usr/local/bin/
      - cp redis-check-aof /usr/local/bin/
      - cp redis-check-dump /usr/local/bin/

config-redis-{{ version }}-executables:
  cmd.wait:
    - watch:
      - cmd: copy-redis-{{ version }}-executables
    - names:
      - mkdir {{ root }}
    {% if root != var %}
      - mkdir {{ var }}
    {% endif %}

{% endif %}  