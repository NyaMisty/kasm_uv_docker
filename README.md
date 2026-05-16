# kasm_uv_docker

一个最小运行时镜像，基于 Kasm Debian，内置：

- Kasm / KasmVNC
- uv
- mihomo
- gost
- curl

不复制项目代码、`.env` 或 `dec/`，仅提供工具运行环境。

## 本地构建

在 WSL 中进入仓库根目录后执行：

```bash
docker build -t kasm_uv_docker:local .
```

## GHCR 镜像

```text
ghcr.io/nyamisty/kasm_uv_docker:latest
```

## 运行

```bash
docker run --rm -it \
  -p 6901:6901 \
  ghcr.io/nyamisty/kasm_uv_docker:latest
```

Kasm Web 入口通常是：

```text
https://localhost:6901
```

## 执行自定义命令

设置 `APP_CMD` 后，启动脚本会在后台执行该命令：

```bash
docker run --rm -it \
  -p 6901:6901 \
  -e APP_CMD='uv --version && mihomo -v && gost -V && curl --version' \
  ghcr.io/nyamisty/kasm_uv_docker:latest
```
