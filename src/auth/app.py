from fastapi import FastAPI
from routers.user import  router as user_router

import uvicorn

app = FastAPI()

app.include_router(user_router, tags=["users"])

@app.get("/")
def read_root():
    return {"On": "Line"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)