# Build for dify-sandbox
# Stage 1: Build wheels requiring Python 3.10
FROM python:3.10 AS builder-310

RUN pip install wheel \
    && mkdir -p /packages

RUN pip wheel -w /packages Janome

# Build for dify-plugins
# Stage 2: Main image based on Python 3.12
FROM python:3.12

RUN pip install pypiserver

RUN pip install wheel \
    && mkdir -p /packages

# Copy packages built with Python 3.10
COPY --from=builder-310 /packages /packages

# Models
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/openai_api_compatible/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/xinference/requirements.txt

# Tools
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/bowenliang123/md_exporter/refs/tags/2.0.0/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/fdb02983rhy/dify-pdf-process-plugin/refs/tags/1.0.0/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-dbquery/refs/tags/0.0.9/db_query/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-mcp_sse/refs/tags/0.2.3/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/firecrawl/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/json_process/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/regex/requirements.txt

# Agent Strategies
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_agent/refs/tags/0.0.1/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-agent-mcp_sse/refs/tags/0.2.4/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/agent-strategies/cot_agent/requirements.txt

# Extensions
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_server/refs/tags/0.0.4/requirements.txt

VOLUME /packages
EXPOSE 8080

CMD ["pypi-server", "run", "-p", "8080", "/packages"]
