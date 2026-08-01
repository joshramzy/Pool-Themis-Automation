FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Goose CLI from the latest GitHub release
RUN curl -fsSL https://github.com/aaif-goose/goose/releases/latest/download/goose-x86_64-unknown-linux-musl.tar.gz \
    | tar xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/goose

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

ENTRYPOINT []

CMD goose serve --port ${PORT:-3000}
