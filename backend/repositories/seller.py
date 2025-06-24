from core.db import AsyncSessionLocal
from sqlalchemy.future import select
from models.seller import Shop

class ShopRepository:
    async def get_all(self):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Shop))
            return result.scalars().all()

    async def get_by_id(self, shop_id: int):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(Shop).where(Shop.shop_id == shop_id))
            return result.scalars().first()

    async def create(self, shop_data: dict):
        async with AsyncSessionLocal() as session:
            shop = Shop(**shop_data)
            session.add(shop)
            await session.commit()
            await session.refresh(shop)
            return shop

shop_repository = ShopRepository()
