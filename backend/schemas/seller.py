from pydantic import BaseModel
from typing import Optional

class ShopBase(BaseModel):
    user_id: int
    shop_name: str
    shop_description: Optional[str] = None
    shop_image_url: Optional[str] = None
    rating: float = 0.0
    location: Optional[str] = None
    is_favorite: bool = False
    is_available: bool = True

class ShopCreate(ShopBase):
    pass

class ShopResponse(ShopBase):
    shop_id: int
    created_at: str

    class Config:
        orm_mode = True
        from_attributes = True
