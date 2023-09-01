FROM python:3.10-slim

ENV POETRY_VERSION=1.1.12

WORKDIR /lambda
COPY lambda/* /lambda/
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie


COPY entry.sh /

# Install the runtime interface client
RUN pip3 install --target /lambda/ awslambdaric \
    && pip install "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry lock --no-update \
    && poetry install --no-interaction --no-ansi \
    && chmod 755 /usr/bin/aws-lambda-rie /entry.sh

ENTRYPOINT [ "/entry.sh" ]

CMD [ "handler.lambda_handler" ]
