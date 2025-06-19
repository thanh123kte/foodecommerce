from fastapi import APIRouter
from schemas.food import FoodCreate, FoodResponse
from services.food import food_service
from typing import List

router = APIRouter()

@router.get("/foods", response_model=List[FoodResponse])
async def get_foods():
    return await food_service.get_all()

@router.get("/foods/{food_id}", response_model=FoodResponse)
async def get_food(food_id: int):
    return await food_service.get_by_id(food_id)

@router.post("/foods", response_model=FoodResponse)
async def create_food(req: FoodCreate):
    return await food_service.create(req)

@router.get("/foods/category/{category_id}", response_model=List[FoodResponse])
async def get_foods_by_category(category_id: int):
    return await food_service.get_by_category(category_id)
