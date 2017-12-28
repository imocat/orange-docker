# orange 镜像

确保已安装 [docker](https://github.com/docker/docker) 和 [docker-compose](https://github.com/docker/compose/releases) 后

### 执行构建

```bash
docker-compose build 
```

### 环境变量说明
| 环境变量 | 说明 |
| :-- | :-- |
| NGINX\_DNS | nginx 的 dns 服务器，默认 114.114.114.114  |
| NGINX\_WORKER\_PROCESSES | nginx 的 worker\_processes 数量，默认会使用 CPU 个数 |
| ORANGE\_API\_USERNAME | orange API username |
| ORANGE\_API\_PASSWORD | orange API password |
| ORANGE\_DB\_HOST | mysql 服务器地址 |
| ORANGE\_DB\_PORT | mysql 服务器端口 |
| ORANGE\_DB\_USER | mysql 数据库用户名 |
| ORANGE\_DB\_PWD | mysql 数据库密码 |
| ORANGE\_DB\_NAME | mysql 数据库名称 |

