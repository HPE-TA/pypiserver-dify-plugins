# Build for dify-sandbox
# Stage 1: Build wheels requiring Python 3.10
FROM python:3.10 AS builder-310

RUN pip install wheel \
    && mkdir -p /packages

RUN pip wheel -w /packages Janome==0.5.0
RUN pip wheel -w /packages python-pptx==1.0.2
RUN pip wheel -w /packages beautifulsoup4==4.14.3

# Build for dify-plugins
# Stage 2: Main image based on Python 3.12
FROM python:3.12

RUN pip install pypiserver uv

RUN pip install wheel \
    && mkdir -p /packages

# Copy packages built with Python 3.10
COPY --from=builder-310 /packages /packages

# You can check dify official plugin's version by the menifest file.
RUN mkdir -p /manifests

# Helper script: download pyproject.toml + uv.lock, export to requirements.txt, build wheels
COPY <<'EOF' /usr/local/bin/build-plugin-wheels.sh
#!/bin/bash
set -e
PLUGIN_PATH="$1"
MANIFEST_NAME="$2"
BASE_URL="https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main"
mkdir -p /tmp/plugin
curl -sf -o /tmp/plugin/pyproject.toml "${BASE_URL}/${PLUGIN_PATH}/pyproject.toml"
curl -sf -o /tmp/plugin/uv.lock "${BASE_URL}/${PLUGIN_PATH}/uv.lock"
cd /tmp/plugin && uv export --frozen --no-hashes -o requirements.txt
pip wheel -w /packages -r /tmp/plugin/requirements.txt
if [ -n "$MANIFEST_NAME" ]; then
    curl -sf -o "/manifests/${MANIFEST_NAME}.yaml" "${BASE_URL}/${PLUGIN_PATH}/manifest.yaml"
fi
rm -rf /tmp/plugin
EOF
RUN chmod +x /usr/local/bin/build-plugin-wheels.sh

# Models
RUN build-plugin-wheels.sh models/openai_api_compatible models-openai_api_compatible
RUN build-plugin-wheels.sh models/xinference models-xinference
RUN build-plugin-wheels.sh models/openai models-openai
RUN build-plugin-wheels.sh models/ollama models-ollama

# Tools
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/bowenliang123/md_exporter/refs/tags/3.6.8/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/fdb02983rhy/dify-pdf-process-plugin/refs/tags/1.0.0/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-dbquery/refs/tags/0.0.11/db_query/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-mcp_sse/refs/tags/0.2.3/requirements.txt
RUN build-plugin-wheels.sh tools/firecrawl tools-firecrawl
RUN build-plugin-wheels.sh tools/json_process tools-json_process
RUN build-plugin-wheels.sh tools/regex tools-regex
RUN build-plugin-wheels.sh tools/dify_extractor tools-dify_extractor
RUN build-plugin-wheels.sh tools/general_chunk tools-general_chunk
RUN build-plugin-wheels.sh tools/parent_child_chunk tools-parent_child_chunk
RUN build-plugin-wheels.sh tools/qa_chunk tools-qa_chunk
RUN build-plugin-wheels.sh tools/chart tools-chart

# Data Sources
RUN build-plugin-wheels.sh datasources/firecrawl_datasource datasources-firecrawl_datasource

# Agent Strategies
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_agent/refs/tags/0.0.1/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-agent-mcp_sse/refs/tags/0.2.4/requirements.txt
RUN build-plugin-wheels.sh agent-strategies/cot_agent agent-strategies-cot_agent

# Extensions
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_server/refs/tags/0.0.4/requirements.txt

VOLUME /packages
EXPOSE 8080

CMD ["pypi-server", "run", "-p", "8080", "/packages"]
