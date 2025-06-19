from core.db import AsyncSessionLocal
from sqlalchemy.future import select
from models.user import User

class UserRepository:
    async def get_user_by_username(self, username: str):
        async with AsyncSessionLocal() as session:
            result = await session.execute(select(User).where(User.username == username))
            user = result.scalars().first()
            return user

    async def create_user(self, user_data: dict):
        async with AsyncSessionLocal() as session:
            user = User(**user_data)
            session.add(user)
            await session.commit()
            await session.refresh(user)
            return user

user_repository = UserRepository()
