# docker-goofys
Dockerized support for @kahing/goofys

Sample usage:

```
docker run \
  -e AWS_ACCESS_KEY_ID=xxxxxxxxxxxxx \
  -e AWS_SECRET_ACCESS_KEY=xxxxxxxxx \
  --security-opt apparmor:unconfined \
  --device /dev/fuse \
  --cap-add SYS_ADMIN \
  --mount type=bind,source=/mnt/test,target=/mnt/test,bind-propagation=rshared \
  --rm -it \
  ghcr.io/nanderson94/goofys \
  goofys -f \
  --endpoint https://minio.example.com \
  samplebucket /mnt/test
```

With some explanation:
* `-e AWS_*` arguments are one possible method to provide AWS secrets, goofys
  can also read from /app/.aws/credentials
* `--security-opt apparmor:unconfined` is required for Ubuntu systems unless
  you create an AppArmor profile to permit docker to mount.
* `--device /dev/fuse` is required for all system to grant goofys access to the
  "fuse" device provided by the host's kernel.
* `--cap-add SYS_ADMIN` is required to issue mount syscalls
* `--mount ...` This is a standard `/mnt/test:/mnt/test`, but definining
  `bind-propagation=rshared` will expose mounts from within the container to
  the host.
* `--rm -it` is mainly for testing, you will want to `--daemonize` this.
* `goofys -f` Runs the application in foreground mode, desireable for docker
* ...And the rest I'll leave to goofys to explain
