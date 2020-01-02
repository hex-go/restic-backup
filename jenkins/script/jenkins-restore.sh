#!/usr/bin/env bash
# 1. inner workspace
cd /root

# 2. export env to set minio connect info
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export RESTIC_REPOSITORY=s3:http:/0.0.0.0:0000/restic-jenkins/
export RESTIC_PASSWORD=

# 3. restore data to /root/restic-jenkins dir
/usr/local/bin/restic restore latest --target .

# 4. cp file prepare to mount
cp -r /root/restic-jenkins/jenkins_home /var/

# 5. docker load image and run container
docker load -i /root/restic-jenkins/img/jenkins.tar
docker run -d \
--name jenkins-dit \
-p 8100:8080 \
--add-host reg.qloud.com:192.168.1.77 \
--add-host reg.qloudhub.com:192.168.40.33 \
-v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
-v $(which docker):/usr/bin/docker \
-u 0 \
reg.qloud.com/qlouddop/jenkins:2.60.3

# 6. cp init file
docker cp /root/restic-jenkins/script/tomcat.cer jenkins-dit:/root
docker cp /root/restic-jenkins/script/indocker.sh jenkins-dit:/root

# 7. exec init-script
docker exec jenkins-dit bash /root/indocker.sh

