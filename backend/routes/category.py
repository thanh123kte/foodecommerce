from fastapi import APIRouter
from schemas.category import CategoryCreate, CategoryResponse
from services.category import category_service
from typing import List

router = APIRouter()

@router.get("/categories", response_model=List[CategoryResponse])
async def get_categories():
    return await category_service.get_all()

@router.get("/categories/{category_id}", response_model=CategoryResponse)
async def get_category(category_id: int):
    return await category_service.get_by_id(category_id)

@router.post("/categories", response_model=CategoryResponse)
async def create_category(req: CategoryCreate):
    return await category_service.create(req)
