FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Install Goose CLI via the official install script
RUN curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh \
    | CONFIGURE=false GOOSE_BIN_DIR=/usr/local/bin bash

# Install ttyd
RUN curl -fsSL -o /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

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

EXPOSE 7681

ENTRYPOINT []

CMD ["/bin/sh", "-c", "ttyd -W -p 7681 -c \"${GOOSE_WEB_USER}:${GOOSE_WEB_PASSWORD}\" goose session"]
