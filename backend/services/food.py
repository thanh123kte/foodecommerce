from repositories.food import food_repository
from schemas.food import FoodCreate, FoodResponse
from fastapi import HTTPException

class FoodService:
    async def get_all(self):
        return [FoodResponse.from_orm(food) for food in await food_repository.get_all()]

    async def get_by_id(self, food_id: int):
        food = await food_repository.get_by_id(food_id)
        if not food:
            raise HTTPException(status_code=404, detail="Food not found")
        return FoodResponse.from_orm(food)

    async def create(self, req: FoodCreate):
        food = await food_repository.create(req.dict())
        return FoodResponse.from_orm(food)

    async def get_by_category(self, category_id: int):
        return [FoodResponse.from_orm(food) for food in await food_repository.get_by_category(category_id)]

food_service = FoodService()
