FROM kalilinux/kali-rolling:latest

# Install domain reconnaissance & pentest tools
RUN apt-get update && \
    apt-get install -y whois dnsutils sublist3r amass gobuster nikto wafw00f \
    python3-pip make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git tree golang \
    && apt-get clean

# Install pyenv
RUN curl https://pyenv.run | bash

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:/root/go/bin:${PATH}"

# Install waybackurls
RUN go install github.com/tomnomnom/waybackurls@latest

# Install FinalRecon
RUN apt-get install -y finalrecon

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
