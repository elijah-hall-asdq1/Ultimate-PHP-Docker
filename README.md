# Ultimate PHP Docker

一体化 **Nginx + PHP-FPM** Docker 镜像，开箱即用，支持 ThinkPHP 和 Laravel 框架。

## 可用版本

| 镜像标签 | PHP 版本 | 适用框架 |
|---------|---------|---------|
| `php-7.4` | 7.4 | ThinkPHP 5/6, Laravel 6-8 |
| `php-8.0` | 8.0 | ThinkPHP 6/8, Laravel 8-9 |
| `php-8.1` | 8.1 | ThinkPHP 6/8, Laravel 9-10 |
| `php-8.2` | 8.2 | ThinkPHP 8, Laravel 10-11 |
| `php-8.3` | 8.3 | ThinkPHP 8, Laravel 11-12 |
| `php-8.4` | 8.4 | ThinkPHP 8, Laravel 12 |

## 快速开始

### 拉取镜像

```bash
docker pull ghcr.io/elijah-hall-asdq1/ultimate-php-docker:php-8.3
```

### 启动容器

```bash
docker run -d \
  --name my-php-app \
  -p 8080:80 \
  -v $(pwd)/your-project:/var/www/html \
  ghcr.io/elijah-hall-asdq1/ultimate-php-docker:php-8.3
```

然后访问 `http://localhost:8080` 即可。

### Docker Compose 示例

```yaml
services:
  app:
    image: ghcr.io/elijah-hall-asdq1/ultimate-php-docker:php-8.3
    ports:
      - "8080:80"
    volumes:
      - ./your-project:/var/www/html
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: app
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:alpine

volumes:
  mysql_data:
```

## 目录结构

```
/var/www/html/          # 项目根目录（挂载你的项目到这里）
  └── public/           # Web 根目录（Nginx 指向此处）
      └── index.php     # 入口文件
```

> **注意**：Nginx 的 `root` 指向 `/var/www/html/public`，这是 ThinkPHP 和 Laravel 的标准目录结构。如果你的项目入口不在 `public/` 目录下，可以自行挂载 Nginx 配置覆盖默认设置。

## 预装 PHP 扩展

pdo_mysql, mysqli, gd, zip, bcmath, opcache, intl, mbstring, xml, pcntl, sockets, redis

## 预装工具

Composer, Git, Curl, Zip/Unzip

## 自定义配置

挂载自定义配置覆盖默认值：

```bash
# 自定义 Nginx
-v ./my-nginx.conf:/etc/nginx/http.d/default.conf

# 自定义 PHP
-v ./my-php.ini:/usr/local/etc/php/conf.d/custom.ini
```

## 构建触发

- **自动触发**：推送代码到 `main` 分支
- **手动触发**：GitHub → Actions → "Build and Push PHP Docker Images" → Run workflow

## License

MIT
