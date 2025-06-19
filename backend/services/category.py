from repositories.category import category_repository
from schemas.category import CategoryCreate, CategoryResponse
from fastapi import HTTPException

class CategoryService:
    async def get_all(self):
        return [CategoryResponse.from_orm(cat) for cat in await category_repository.get_all()]

    async def get_by_id(self, category_id: int):
        cat = await category_repository.get_by_id(category_id)
        if not cat:
            raise HTTPException(status_code=404, detail="Category not found")
        return CategoryResponse.from_orm(cat)

    async def create(self, req: CategoryCreate):
        cat = await category_repository.create(req.dict())
        return CategoryResponse.from_orm(cat)

category_service = CategoryService()
