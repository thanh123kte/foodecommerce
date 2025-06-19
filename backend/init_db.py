import asyncio
from core.db import engine
from models.user import Base as UserBase
from models.category import Base as CategoryBase

async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(UserBase.metadata.create_all)
        await conn.run_sync(CategoryBase.metadata.create_all)

if __name__ == "__main__":
    asyncio.run(init_db())
