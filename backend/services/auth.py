# services/auth.py
from fastapi import HTTPException
from repositories.user import user_repository
from schemas.auth import LoginRequest, RegisterRequest, LoginResponse, Token
from schemas.user import UserResponse
from core.security import create_access_token

class AuthService:
    async def login_user(self, req: LoginRequest) -> LoginResponse:
        user = await user_repository.get_user_by_username(req.username)
        if user is None or getattr(user, "password", None) != req.password:
            raise HTTPException(status_code=401, detail="Sai tài khoản hoặc mật khẩu")
        access_token = create_access_token(data={"sub": str(user.username)})
        return LoginResponse(
            token=Token(access_token=access_token),
            user=UserResponse(username=str(user.username), email=str(user.email))
        )

    async def register_user(self, req: RegisterRequest) -> dict:
        existing = await user_repository.get_user_by_username(req.username)
        if existing:
            raise HTTPException(status_code=400, detail="Tài khoản đã tồn tại")
        user_data = {
            "username": req.username,
            "password": req.password, # Trong thực tế cần hash mật khẩu trước khi lưu
            "email": req.email,
        }
        await user_repository.create_user(user_data)
        return {"message": "Đăng ký thành công"}

    async def get_user_profile(self, username: str) -> UserResponse:
        user = await user_repository.get_user_by_username(username)
        if not user:
            raise HTTPException(status_code=404, detail="Người dùng không tồn tại")
        return UserResponse(username=str(user.username), email=str(user.email))

# Khởi tạo instance của service
auth_service = AuthService()