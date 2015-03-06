README
======

## `salted-redis`
A salt state to install redis as a service.

## About
This state is designed to enable the installation of any supported Redis release from source, which defaults to the current stable release. This can be changed by specifiying another release number and its corresponding checksum in the pillar.

The end result, using the default settings, is redis installed as a service consistent with [the redis quickstart instructions](http://redis.io/topics/quickstart). The only deviation from the quickstart is that all redis executables from the compile are copied to `/usr/local/bin`.
 
Installation from package is not supported and will not be supported. 

The formula currently depends on `init.d` for service management. This is not meant as a statement or comment for or against `upstart` or `systemd`; `init.d` is what is documented in Redis' quick start page. 

## Usage
Add this state to your salt repo and create a pillar file or files for this state to customize the installation to suit your needs. _At minimum, the checksums portion of the `pillar.example` file is required._

For an example, please refer to the redis states in the base pillar of my [saltbase](https://github.com/mohae/saltbase) repo.  

## Pillar
The included `pillar.example` includes everything needed for the state to install the current Redis stable release and the checksums for all other currently supported versions. For customization of the Redis installation in your environment, only the `redis-server` portion needs to be changed. The `redis-checksum` contains all currently valid checksums.

`redis-server`: ID for server configuration settings.
`enabled`: Boolean for whether or not Redis is enabled. If it is, redis will be installed and configured.
`loglevel`: The loglevel to use. Default: notice
`port`: The port that redis will be listening on. Default: 6379
`root`: The root directory for redis. Default: /etc/redis
`var`: The var directory for redis. Default: /etc/redis
`work`: The work directory for redis installs. This is where redis is downloaded and compiled. Default: /tmp/redis
`version`: The version of redis that will be installed. Default: stable.

`redis-checksums`: ID for the checksums of the various redis versions. These are mostly obtained from [redis-hashes](https://github.com/antirez/redis-hashes). Each checksum has its own id in the form of `redis-release-checksum`, with the exception of `redis-stable`, whose id is `redis-stable-checksum`.
`checksum`: The checksum of the release tarball.
`algo`: The algorithm for the checksum, currently all checksums are `sha1`.

If there are recent releases that are not part of the `redis-checksum`, either file an issue or submit a pull request.

Please refer to `pillar.example` for a complete pillar. My [salted](https://github.com/mohae/salted) repo splits the example pillar up into two separate pillar states: `server.sls` and `checksums.sls`. As a result, the structure of salted's pillar for redis is:

```
pillar\redis
pillar\redis\init.sls
pillar\redis\checksums.sls
pillar\redis\server.sls
```

That is just a preference on my part, putting all of the pillar information in `pillar/redis.sls` or `pillar/redis/init.sls` works too.

### Pillar note
The checksum for stable may be out of sync if there has been a recent stable release for Redis. If an error occurs becuase the downloaded file's checksum does not match the checksum for `stable`, please either file an issue or a pull request with the updated checksum. 

A workaround is to update your redis pillar data for `stable` to the current stable release's checksum.

## License
This formula is under the MIT License. Please refer to the included LICENSE file for more information.

Everything is provided as-is, with no warrant or guarantee provided, either explicitly or implied.
