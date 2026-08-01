FROM ubuntu:24.04

RUN echo "cache-bust: 2026-08-01T02:16:00Z" && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg bzip2 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install FastAPI/uvicorn (--break-system-packages needed: Ubuntu 24.04's
# system Python is PEP 668-managed and refuses plain pip installs)
RUN pip3 install --no-cache-dir --break-system-packages fastapi uvicorn

# Install Goose CLI via the official install script
RUN curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh \
    | CONFIGURE=false GOOSE_BIN_DIR=/usr/local/bin bash

# Install 1Password CLI
RUN curl -sSfo op.deb "https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb" \
    && apt-get update \
    && apt-get install -y ./op.deb \
    && rm op.deb \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (avoids Ubuntu's snap-wrapped chromium-browser)
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/google-chrome-stable
ENV GOOSE_DISABLE_KEYRING=1

WORKDIR /app
COPY api.py /app/

EXPOSE 8080

ENTRYPOINT []

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8080"]
