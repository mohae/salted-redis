# salt/dev/redis/init.sls
# Installs redis based on the pillar settings.

{% if salt['pillar.get']('redis-server:enabled') %}
{% set version = salt['pillar.get']('redis-server:version', {}) %}
{% set root = salt['pillar.get']('redis-server:root', '/etc/redis') %}
{% set var = salt['pillar.get']('redis-server:var', '/etc/var') %}
{% set port = salt['pillar.get']('redis-server:port', 6379) %}
{% set checksum_info = salt['pillar.get']('redis-checksums:redis-' + version + '-checksum', {}) %}
{% set checksum = checksum_info.get('checksum', '') %}
{% set algo = checksum_info.get('algo', 'sha1') %}

redis-dependencies:
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

download-redis:
  archive.extracted:
    - name: {{ root }}/
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    - source_hash: {{ algo }}={{ checksum }}
    - archive_format: tar
#    - tar_options: zv
    - if_missing: {{ root }}/redis-{{ version }}
    - require:
      - pkg: redis-dependencies

redis-make-install:
  cmd.wait:
    - cwd: {{ root }}/redis-{{ version }}
    - names:
      - make
      - make install
    - require:
      - archive: download-redis
{% endif %}
