from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    username: str
    email: EmailStr

class UserInDB(UserBase):
    hashed_password: str # Khi bạn thêm hash mật khẩu

class UserResponse(UserBase):
    pass