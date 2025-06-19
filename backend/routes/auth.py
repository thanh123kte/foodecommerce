# routes/auth.py
from fastapi import APIRouter, Depends, HTTPException
from schemas.auth import LoginRequest, RegisterRequest, LoginResponse
from schemas.user import UserResponse
from services.auth import auth_service
from core.security import oauth2_scheme, decode_token

router = APIRouter()

@router.post("/login", response_model=LoginResponse)
async def login_route(req: LoginRequest):
    return await auth_service.login_user(req)

@router.post("/register")
async def register_route(req: RegisterRequest):
    return await auth_service.register_user(req)

@router.get("/profile", response_model=UserResponse)
async def get_profile_route(token: str = Depends(oauth2_scheme)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Token không hợp lệ")
    username = payload.get("sub")
    if not username:
        raise HTTPException(status_code=401, detail="Token không hợp lệ hoặc thiếu thông tin người dùng")
    return await auth_service.get_user_profile(username)