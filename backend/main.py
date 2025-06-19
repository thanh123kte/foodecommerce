# FastAPI example for JWT Auth

from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel
from datetime import datetime, timedelta
import jwt

SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

fake_users_db = {
    "admin": {
        "username": "admin",
        "password": "123123",
        "email": "admin@example.com",
    }
}

class LoginRequest(BaseModel):
    username: str
    password: str

class RegisterRequest(BaseModel):
    username: str
    password: str
    email: str
    mobile: str


def create_access_token(data: dict, expires_delta: timedelta = timedelta(minutes=15)):
    to_encode = data.copy()
    expire = datetime.now() + expires_delta
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def decode_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.PyJWTError:
        return None


@app.post("/api/auth/login")
def login(req: LoginRequest):
    user = fake_users_db.get(req.username)
    if user and user["password"] == req.password:
        token = create_access_token({"sub": req.username})
        return {"token": token, "user": {"username": user["username"], "email": user["email"]}}
    raise HTTPException(status_code=401, detail="Sai tài khoản hoặc mật khẩu")


@app.post("/api/auth/register")
def register(req: RegisterRequest):
    if req.username in fake_users_db:
        raise HTTPException(status_code=400, detail="Tài khoản đã tồn tại")
    fake_users_db[req.username] = {
        "username": req.username,
        "password": req.password,
        "email": req.email
    }
    return {"message": "Đăng ký thành công"}


@app.get("/api/auth/profile")
def get_profile(token: str = Depends(oauth2_scheme)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Token không hợp lệ")
    username = payload.get("sub")
    user = fake_users_db.get(username)
    return {"username": username, "email": user["email"] if user else "unknown"}
