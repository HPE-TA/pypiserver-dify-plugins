FROM python:3.12

RUN pip install pypiserver

RUN pip install wheel \
    && mkdir -p /packages

RUN pip wheel -w /packages -r https://raw.githubusercontent.com/bowenliang123/md_exporter/refs/tags/2.0.0/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_agent/refs/tags/0.0.1/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/hjlarry/dify-plugin-mcp_server/refs/tags/0.0.4/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/fdb02983rhy/dify-pdf-process-plugin/refs/tags/1.0.0/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-agent-mcp_sse/refs/tags/0.2.4/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-mcp_sse/refs/tags/0.2.3/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-dbquery/refs/tags/0.0.9/db_query/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/agent-strategies/cot_agent/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/openai/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/xinference/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/firecrawl/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/json_process/requirements.txt

VOLUME /packages
EXPOSE 8080

CMD ["pypi-server", "run", "-p", "8080", "/packages"]
