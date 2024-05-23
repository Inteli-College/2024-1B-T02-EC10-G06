from fastapi import FastAPI
from routers.pyxi import  router as pyxi_router
from routers.ticket import router as ticket_router
from routers.medicines import router as medicines_router

import uvicorn

app = FastAPI()

app.include_router(pyxi_router)
app.include_router(medicines_router)
app.include_router(ticket_router)

@app.get("/")
def read_root():
    return {"On": "Line"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5001)
