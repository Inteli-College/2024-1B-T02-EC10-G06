from fastapi import FastAPI, Depends
from routers.user import router as user_router
from routers.pyxi import router as pyxi_router
from routers.tickt import router as tickt_router
from routers.medicine import router as medicine_router

import uvicorn

app = FastAPI()

app.include_router(user_router, tags=["users"])
app.include_router(pyxi_router, tags=["pyxis"])
app.include_router(tickt_router, tags=["tickts"])
app.include_router(medicine_router, tags=["medicines"])

@app.get("/")
def read_root():
    return {"On": "Line"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5001)