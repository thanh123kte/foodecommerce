from pydantic import BaseModel
from typing import Optional

class CategoryBase(BaseModel):
    category_name: str
    category_icon_url: Optional[str] = None

class CategoryCreate(CategoryBase):
    pass

class CategoryResponse(CategoryBase):
    category_id: int

    class Config:
        orm_mode = True
        from_attributes = True
