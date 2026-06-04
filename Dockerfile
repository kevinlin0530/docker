FROM python:3.9

WORKDIR /app
COPY . .
# 安装 Google Chrome
RUN apt-get update -y && apt-get install -y wget unzip curl

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable

RUN pip install -r requirements.txt 

CMD ["python", "app.py"]



FROM debian:testing-slim

# ---------------------------- 基本安裝 ----------------------------------
WORKDIR /app

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        build-essential gdb lcov \
        pkg-config libbz2-dev libffi-dev \
        libgdbm-dev libgdbm-compat-dev liblzma-dev \
        libncurses5-dev libreadline-dev libsqlite3-dev \
        libssl-dev lzma liblzma-dev tk-dev \
        uuid-dev zlib1g-dev wget unzip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------- 安裝 Python 3.14.2 ----------------------------------
RUN wget https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz && \
   tar -xvf Python-3.14.2.tgz && \
   cd Python-3.14.2 && \
   ./configure --enable-optimizations --with-lto --enable-shared && \
   make -j $(nproc) && \
   make altinstall && \
   cd .. && \
   rm -rf Python-3.14.2 && \
   rm Python-3.14.2.tgz

# ---------------------------- 建立 symlink ----------------------------------
RUN ln -s /usr/local/bin/python3.14 /usr/local/bin/python && \
   ln -s /usr/local/bin/python3.14 /usr/local/bin/python3 && \
   ln -s /usr/local/bin/pip3.14 /usr/local/bin/pip && \
   ln -s /usr/local/bin/pip3.14 /usr/local/bin/pip3

# ---------------------------- 更新 pip ----------------------------------
RUN pip install --upgrade pip setuptools

# ✅ (可選) 解決 shared lib 問題
ENV LD_LIBRARY_PATH=/usr/local/lib
