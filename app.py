from typing import Optional
from fastapi import FastAPI
import uvicorn

app = FastAPI() # 建立一個 Fast API application

@app.get("/test_url") # 指定 api 路徑 (get方法)
def read_root():
    return {"Hello": "World"}


if __name__ == '__main__':
    uvicorn.run("app:app", host="0.0.0.0", port=8000, log_level="info")