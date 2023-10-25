# 使用官方 Python 镜像作为基础镜像
FROM python:3.9

# 设置工作目录
WORKDIR /app

# 安装 Google Chrome
RUN apt-get update -y && apt-get install -y wget unzip curl

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable

# 复制应用程序代码到容器中
COPY . .

# 安装应用程序依赖
RUN pip install -r requirements.txt 

# 指定容器启动时要运行的命令
CMD ["python", "app.py"]
