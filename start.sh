#!/bin/sh
uvicorn api:app --host 0.0.0.0 --port 8080 &
ttyd -W -p 7681 -c "${GOOSE_WEB_USER}:${GOOSE_WEB_PASSWORD}" goose session &
wait
