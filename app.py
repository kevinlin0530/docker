from fastapi import FastAPI
from datetime import datetime
from bs4 import BeautifulSoup as bs
import requests as req
import mysql.connector
import uvicorn

app = FastAPI() # 建立一個 Fast API application

@app.get("/test_url") # 指定 api 路徑 (get方法)
def read_root():
    return {"Hello": "World"}

@app.post("/webscrap")
def webscrping():
    conn = mysql.connector.connect(
        host='35.201.205.128',
        user='root',
        password='d]a)Qf8=moJ"YiOU',
        database = 'gitaction',
    )

    cursor = conn.cursor()

    def check_data(title,timestamp):
        cursor.execute("select %s,%s from gitaction",(title,timestamp))
        result = cursor.fetchone()
        if result:
            return True
        else:
            return False

    def insert_data(title, timestamp):
        cursor.execute('INSERT INTO test (title, timestamp) VALUES (%s, %s)', (title, timestamp))
        conn.commit()

    def getData(url):
        request=req.get(url, headers={
            "cookie":"over18=1",
            "user-agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36"
        })

        root=bs.BeautifulSoup(request.text,"html.parser")
        titles=root.find_all("div",class_="title")
        for title in titles:
            if title.a != None:
                title_string = title.a.string
                current_time = datetime.now()
                if check_data(title_string,current_time):
                    print(f"title:{title_string},time:{current_time}")
                    insert_data(title_string, current_time)
                else:
                    print(f"title:{title_string},time:{current_time}")
                    insert_data(title_string, current_time)
        nextLink=root.find("a", string="‹ 上頁")
        return nextLink["href"]

    pageURL="https://www.ptt.cc/bbs/movie/index.html"
    count=0
    getData(pageURL)
    while count<2:
        pageURL="https://www.ptt.cc"+getData(pageURL)
        count+=1
    conn.close()

if __name__ == '__main__':
    uvicorn.run("app:app", host="0.0.0.0", port=8000, log_level="info")