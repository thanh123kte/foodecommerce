from core.db import AsyncSessionLocal
from sqlalchemy.future import select
from models.category import Category

class CategoryRepository:
    async def get_all(self):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Category))
            return result.scalars().all()

    async def get_by_id(self, category_id: int):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Category).where(Category.category_id == category_id))
            return result.scalars().first()

    async def create(self, category_data: dict):
        async with AsyncSessionLocal() as session:
            category = Category(**category_data)
            session.add(category)
            await session.commit()
            await session.refresh(category)
            return category

category_repository = CategoryRepository()
