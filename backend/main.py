# main.py
from fastapi import FastAPI
from routes import auth, category, food, seller

app = FastAPI(title="Authentication API")

app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])
app.include_router(category.router, prefix="/api", tags=["Category"])
app.include_router(food.router, prefix="/api", tags=["Food"])
app.include_router(seller.router, prefix="/api", tags=["Shop"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI Auth API"}