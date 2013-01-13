##Prepare release environment
```bash
#cd /data/projects
#git clone git@github.com:amuraru/zeromq-maven.git
export MAVEN_DIR=/data/projects/zeromq-maven
export SNAPSHOT_REPO="file://${MAVEN_DIR}/snapshots"
export RELEASE_REPO="file://${MAVEN_DIR}/releases"

#optionally used to tag native jar
export OS_DISTRO="ubuntu12.04"
export ZMQ_VERSION="zmq2"
```

##Build and publish snapshots
```bash
cd /data/projects/0mq/jzmq
#Build
./autogen.sh && ./configure && make
#Deploy snapshots
mvn -Dos.distro="${OS_DISTRO}" -Dzmq.version="${ZMQ_VERSION}" \
    -Pdeploy-local-maven \
    clean deploy
```


##Build and publish **release** artifacts

```bash
#Switch to jzmq dir
cd /data/projects/0mq/jzmq
#Build
./autogen.sh && ./configure && make
#Deploy release artifacts locally
git co .
mvn -Dos.distro="${OS_DISTRO}" -Dzmq.version="${ZMQ_VERSION}" \
    -Pdeploy-local-maven \
    release:clean release:prepare release:perform
git push --tags
```


###Upload artifacts to git-backed maven repo
```bash
cd $MAVEN_DIR
sh ./update-directory-index.sh
git add *
git commit -m "Released a new version vX.X.X"
git push -f
```
