# # backend/main.py
# from fastapi import FastAPI
# from routes import router
# import uvicorn

# app = FastAPI()
# app.include_router(router)

# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)

# backend/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import router
import uvicorn

app = FastAPI()

# Allow all origins for dev (you can restrict it later)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your Flutter app's URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router)

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
