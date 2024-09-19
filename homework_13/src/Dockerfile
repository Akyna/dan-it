FROM python:3.10-alpine
ENV APP_DIRR='/home/akyna/app'
ENV USER='akyna'
ENV GROUPNAME="${USER}"

RUN apk update && pip install --no-cache-dir pipenv

# Create a group and user for Linux alpine
RUN addgroup -S "${GROUPNAME}" && adduser -S "${USER}" -G "${GROUPNAME}"

WORKDIR "${APP_DIRR}"
#RUN chown -R akyna:akyna /home/akyna/app

COPY --chown="${USER}":"${USER}" Pipfile Pipfile.lock bootstrap.sh gunicorn_config.py ./
COPY --chown="${USER}":"${USER}" app ./app

## Install API dependencies
RUN pipenv install --system --deploy

# Tell docker that all future commands should run as the akyna user
USER "${USER}"

## Start app
EXPOSE 8000
ENTRYPOINT ["/home/akyna/app/bootstrap.sh"]
