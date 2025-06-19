from pydantic import BaseModel

from schemas.user import UserResponse

class LoginRequest(BaseModel):
    username: str
    password: str

class RegisterRequest(BaseModel):
    username: str
    password: str
    email: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class LoginResponse(BaseModel):
    token: Token
    user: UserResponse 