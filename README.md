# Pypi Server for Dify

- Dify: v1.14.2
       - langgenius/dify-sandbox:0.2.15: Python 3.14.4
       - langgenius/dify-plugin-daemon:0.6.1-local: Python 3.12.3

## Dify Configuration Update

- Update the sandbox environment variables in `docker/.env`:

```diff
--- docker/.env.example 2026-07-08 13:48:01.249534611 +0900
+++ docker/.env 2026-07-24 17:41:00.673080214 +0900
@@ -190,7 +190,8 @@
 SANDBOX_HTTP_PROXY=http://ssrf_proxy:3128
 SANDBOX_HTTPS_PROXY=http://ssrf_proxy:3128
 SANDBOX_PORT=8194
-PIP_MIRROR_URL=
+PIP_MIRROR_URL=http://host.docker.internal:8080/simple
+PIP_TRUSTED_HOST=host.docker.internal
 SSRF_PROXY_HTTP_URL=http://ssrf_proxy:3128
 SSRF_PROXY_HTTPS_URL=http://ssrf_proxy:3128
 SSRF_HTTP_PORT=3128
 ```

- Add PIP_TRUSTED_HOST to the sandbox environment variables in `docker/docker-compose.yaml`:

```diff
--- docker/docker-compose.yaml
+++ docker/docker-compose.yaml
@@ -561,6 +561,7 @@ services:
       PLUGIN_STDIO_BUFFER_SIZE: ${PLUGIN_STDIO_BUFFER_SIZE:-1024}
       PLUGIN_STDIO_MAX_BUFFER_SIZE: ${PLUGIN_STDIO_MAX_BUFFER_SIZE:-5242880}
       PIP_MIRROR_URL: ${PIP_MIRROR_URL:-}
+      PIP_TRUSTED_HOST: ${PIP_TRUSTED_HOST:-}
       PLUGIN_STORAGE_TYPE: ${PLUGIN_STORAGE_TYPE:-local}
       PLUGIN_STORAGE_LOCAL_ROOT: ${PLUGIN_STORAGE_LOCAL_ROOT:-/app/storage}
       PLUGIN_INSTALLED_PATH: ${PLUGIN_INSTALLED_PATH:-plugin}
```
