# main.py
from fastapi import FastAPI
from routes import auth

app = FastAPI(title="Authentication API")

app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI Auth API"}