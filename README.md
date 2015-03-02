README
======

## `redis-formula-mohae`
This is a redis formula. Some of the design decisions are based on https://github.com/saltstack-formulas/redis-formula. As such, there may be pieces that do not make a lot of sense, because, frankly, I found a lot that didn't make sense in the original formula.

*caveat: there may be things in this formula that don't make sense to you either.*

## About
This formula is designed to enable the installation of any supported Redis release from source. Installation from package is not supported and will not be supported.

The final installation will include all of the Redis executables being placed in `/user/local/bin/`. 

The formula currently depends on `init.d` for service management. This is not meant as a statement or comment for or against `upstart` or `systemd`; `init.d` is what is documented in Redis' quick start page. 

## Usage
Use as you would other Saltstack Formulas.

## Pillar
The included `pillar.example` includes everything needed for the formula to install Redis 2.8.19 and the checksums for all other currently supported versions. For customization of the Redis installation in your environment, only the `redis-server` portion needs to be changed. The `redis-checksum` contains all currently valid checksums.

If there are recent releases that are not part of the `redis-checksum`, either file an issue or submit a pull request.

## License
This formula is under the MIT License. Please refer to the included LICENSE file for more information.

Everything is provided as-is, with no warrant or guarantee provided, either explicitly or implied.