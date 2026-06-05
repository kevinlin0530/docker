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
