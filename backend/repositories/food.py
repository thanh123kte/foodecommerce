from core.db import AsyncSessionLocal
from sqlalchemy.future import select
from models.food import Food

class FoodRepository:
    async def get_all(self):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Food))
            return result.scalars().all()

    async def get_by_id(self, food_id: int):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Food).where(Food.food_id == food_id))
            return result.scalars().first()

    async def create(self, food_data: dict):
        async with AsyncSessionLocal() as session:
            food = Food(**food_data)
            session.add(food)
            await session.commit()
            await session.refresh(food)
            return food

    async def get_by_category(self, category_id: int):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Food).where(Food.food_category_id == category_id))
            return result.scalars().all()

food_repository = FoodRepository()
