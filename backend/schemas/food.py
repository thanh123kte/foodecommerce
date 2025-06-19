from pydantic import BaseModel
from typing import Optional

class FoodBase(BaseModel):
    user_id: int
    food_category_id: int
    food_name: str
    food_description: str
    food_price: float
    is_available: bool = True

class FoodCreate(FoodBase):
    pass

class FoodResponse(FoodBase):
    food_id: int
    created_at: str

    class Config:
        orm_mode = True
        from_attributes = True
