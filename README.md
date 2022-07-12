# webdav-server

ossfs允许在Linux系统中将对象存储OSS的存储空间（Bucket）挂载到本地文件系统。挂载完成后，您能够像操作本地文件一样操作OSS的对象（Object），从而实现数据共享。

阿里云提供的ossfs只有Ubuntu x64, Centos x64版本，所以我用docker打包一个镜像，理论上支持所有平台的，用来把阿里云OSS挂载到docker中，并用go+nginx的方式实现webdav

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

