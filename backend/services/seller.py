from repositories.seller import shop_repository
from schemas.seller import ShopCreate, ShopResponse
from fastapi import HTTPException

class ShopService:
    async def get_all(self):
        return [ShopResponse.from_orm(shop) for shop in await shop_repository.get_all()]

    async def get_by_id(self, shop_id: int):
        shop = await shop_repository.get_by_id(shop_id)
        if not shop:
            raise HTTPException(status_code=404, detail="Shop not found")
        return ShopResponse.from_orm(shop)

    async def create(self, req: ShopCreate):
        shop = await shop_repository.create(req.dict())
        return ShopResponse.from_orm(shop)

shop_service = ShopService()
