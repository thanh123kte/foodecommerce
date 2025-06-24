from fastapi import APIRouter
from schemas.seller import ShopCreate, ShopResponse
from services.seller import shop_service
from typing import List

router = APIRouter()

@router.get("/shops", response_model=List[ShopResponse])
async def get_shops():
    return await shop_service.get_all()

@router.get("/shops/{shop_id}", response_model=ShopResponse)
async def get_shop(shop_id: int):
    return await shop_service.get_by_id(shop_id)

@router.post("/shops", response_model=ShopResponse)
async def create_shop(req: ShopCreate):
    return await shop_service.create(req)
