FROM pypiserver/pypiserver:v2.4

COPY ./requirements /requirements

RUN pip install wheel \
    && mkdir -p /packages \
    && pip wheel -r /requirements/openai_api_compatible/requirements.txt -w /packages \
    && pip wheel -r /requirements/xinference/requirements.txt -w /packages \
    && pip wheel -r /requirements/json_process/requirements.txt -w /packages \
    && pip wheel -r /requirements/md_exporter/requirements.txt -w /packages \
    && pip wheel -r /requirements/dify-pdf-process-plugin/requirements.txt -w /packages \
    && pip wheel -r /requirements/dify-plugin-agent-mcp_sse/requirements.txt -w /packages

VOLUME /packages
EXPOSE 8080

CMD ["run", "-p", "8080", "/packages"]
