FROM kalilinux/kali-rolling:latest

# Install domain reconnaissance & pentest tools + Android tools + Frida
RUN apt-get update && \
    apt-get install -y whois dnsutils sublist3r amass gobuster nikto wafw00f \
    python3-pip make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl wget \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git tree golang \
    adb fastboot android-tools-adb android-tools-fastboot \
    kali-tools-top10 \
    && apt-get clean

# Upgrade pip and install frida-tools
RUN pip3 install --upgrade pip --break-system-packages && \
    pip3 install frida-tools --break-system-packages

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
