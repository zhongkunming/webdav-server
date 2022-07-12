# webdav-server

ossfs允许在Linux系统中将对象存储OSS的存储空间（Bucket）挂载到本地文件系统。挂载完成后，您能够像操作本地文件一样操作OSS的对象（Object），从而实现数据共享。

阿里云提供的ossfs二进制文件只有Ubuntu x64, Centos x64。 所以我利用docker从源码重新编译，最后打包了一个镜像，理论上支持所有平台的。
通过容器可以把oss挂载到docker中，并用go实现webdav并通过和ngixn结合的方式来实现一个简易的webdav服务器。

docker宿主机可通过容器的ip+port的方式连接，若docker运行在服务器中，可通过-p的方式把容器端口暴露，或者通过docker-connect项目或者其他方式来实现网络转发

### go webdav

```
-dir string
-port int
	监听端口，默认: 8081
-prefix string
	URL前缀，默认: 空
-url string
	webdav根路径，默认 / 
```

### docker 打包

```
docker build ossfs:v1 .
```

### 运行容器

```
docker run -di --rm --name ossfs \
 --cap-add SYS_ADMIN --device /dev/fuse \
 --env BucketName=yourBucketName \
 --env AccessKeyId=yourAK \
 --env AccessKeySecret=youSK \
 --env EndPoint=yourEndPoint \
 -p 80:80
 ossfs:v1
```

