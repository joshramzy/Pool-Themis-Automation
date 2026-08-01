#!/bin/sh
exec goose serve --port ${PORT:-3000}
