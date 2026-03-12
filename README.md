# Pypi Server for Dify

## Dify Configuration Update

### Sandbox

- Update the sandbox environment variables in `docker/.env`:

```diff
--- docker/.env.example 2026-02-18 15:15:56.527218107 +0900
+++ docker/.env 2026-03-12 12:44:21.428724401 +0900
@@ -1409,7 +1409,8 @@
 # API side timeout (configure to match the Plugin Daemon side above)
 PLUGIN_DAEMON_TIMEOUT=600.0
 # PIP_MIRROR_URL=https://pypi.tuna.tsinghua.edu.cn/simple
-PIP_MIRROR_URL=
+PIP_MIRROR_URL=http://host.docker.internal:8080/simple
+PIP_TRUSTED_HOST=host.docker.internal

 # https://github.com/langgenius/dify-plugin-daemon/blob/main/.env.example
 # Plugin storage type, local aws_s3 tencent_cos azure_blob aliyun_oss volcengine_tos
```

- Add PIP_TRUSTED_HOST to the sandbox environment variables in `docker/docker-compose.yaml`:

```diff
diff --git docker/docker-compose.yaml docker/docker-compose.yaml
index 6340dd290e..6bd280a8fe 100644
--- docker/docker-compose.yaml
+++ docker/docker-compose.yaml
@@ -954,6 +954,7 @@ services:
       HTTPS_PROXY: ${SANDBOX_HTTPS_PROXY:-http://ssrf_proxy:3128}
       SANDBOX_PORT: ${SANDBOX_PORT:-8194}
       PIP_MIRROR_URL: ${PIP_MIRROR_URL:-}
+      PIP_TRUSTED_HOST: ${PIP_TRUSTED_HOST:-}
     volumes:
       - ./volumes/sandbox/dependencies:/dependencies
       - ./volumes/sandbox/conf:/conf
```

- Configure the PIP mirror URL and trusted host in `docker/volumes/sandbox/conf/config.yaml`:

```diff
diff --git docker/volumes/sandbox/conf/config.yaml docker/volumes/sandbox/conf/config.yaml
index 8c1a1deb54..c26a8e3666 100644
--- docker/volumes/sandbox/conf/config.yaml
+++ docker/volumes/sandbox/conf/config.yaml
@@ -7,7 +7,389 @@ max_requests: 50
 worker_timeout: 5
 python_path: /usr/local/bin/python3
 enable_network: True # please make sure there is no network risk in your environment
-allowed_syscalls: # please leave it empty if you have no idea how seccomp works
+python_pip_mirror_url: http://host.docker.internal:8080/simple
+allowed_syscalls:
+  - 0
+  - 1
+  - 2
+  - 3

```

- Add the required Python packages to `docker/volumes/sandbox/dependencies/python-requirements.txt`:

```diff
diff --git docker/volumes/sandbox/dependencies/python-requirements.txt docker/volumes/sandbox/dependencies/python-requirements.txt
new file mode 100644
index 0000000000..96c9b571cd
--- /dev/null
+++ docker/volumes/sandbox/dependencies/python-requirements.txt
@@ -0,0 +1,2 @@
+Janome==0.5.0
+python-pptx==1.0.2
```
