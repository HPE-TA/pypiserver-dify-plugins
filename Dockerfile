FROM python:3.12

RUN pip install pypiserver

COPY ./requirements /requirements

RUN pip install wheel \
    && mkdir -p /packages

RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/openai/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/models/xinference/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/langgenius/dify-official-plugins/refs/heads/main/tools/json_process/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/bowenliang123/md_exporter/refs/heads/main/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/fdb02983rhy/dify-pdf-process-plugin/refs/heads/main/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-agent-mcp_sse/refs/heads/main/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-mcp_sse/refs/heads/main/requirements.txt
RUN pip wheel -w /packages -r https://raw.githubusercontent.com/junjiem/dify-plugin-tools-dbquery/refs/heads/main/db_query/requirements.txt

VOLUME /packages
EXPOSE 8080

CMD ["pypi-server", "run", "-p", "8080", "/packages"]
