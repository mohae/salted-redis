README
======

## `redis-formula-mohae`
This is a redis formula. Some of the design decisions are based on https://github.com/saltstack-formulas/redis-formula. As such, there may be pieces that do not make a lot of sense, because, frankly, I found a lot that didn't make sense in the original formula.

## About
This formula is designed to enable the installation of any supported Redis release from source, which defaults to the current stable release. This can be changed by specifiying another release number and its corresponding checksum in the pillar.

The end result, using the default settings, is redis installed as a service consistent with [the redis quickstart instructions](http://redis.io/topics/quickstart). The only deviation from the quickstart is that all redis executables from the compile are copied to `/usr/local/bin`.
 
Installation from package is not supported and will not be supported. 

The formula currently depends on `init.d` for service management. This is not meant as a statement or comment for or against `upstart` or `systemd`; `init.d` is what is documented in Redis' quick start page. 

## Usage
Use as you would other Saltstack Formulas. Create a pillar file or files for this formula to customize the installation to suit your needs. _At minimum, the checksums portion of the `pillar.example` file is required._

For an example, please refer to the redis states in the base pillar of my [saltbase](https://github.com/mohae/saltbase) repo.  

## Pillar
The included `pillar.example` includes everything needed for the formula to install Redis 2.8.19 and the checksums for all other currently supported versions. For customization of the Redis installation in your environment, only the `redis-server` portion needs to be changed. The `redis-checksum` contains all currently valid checksums.

If there are recent releases that are not part of the `redis-checksum`, either file an issue or submit a pull request.

### Pillar note
The checksum for stable may be out of sync if there has been a recent stable release for Redis. If an error occurs becuase the downloaded file's checksum does not match the checksum for `stable`, please either file an issue or a pull request with the updated checksum. 

A workaround is to update your redis pillar data for `stable` to the current stable release's checksum.

## License
This formula is under the MIT License. Please refer to the included LICENSE file for more information.

Everything is provided as-is, with no warrant or guarantee provided, either explicitly or implied.