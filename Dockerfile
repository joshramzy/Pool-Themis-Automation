FROM ghcr.io/aaif-goose/goose:latest

# Install 1Password CLI
RUN curl -sSfo op.deb "https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb" \
    && apt-get update \
    && apt-get install -y ./op.deb \
    && rm op.deb \
    && rm -rf /var/lib/apt/lists/*

# Install headless Chromium
RUN apt-get update \
    && apt-get install -y --no-install-recommends chromium \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium

CMD goose serve --port $PORT
