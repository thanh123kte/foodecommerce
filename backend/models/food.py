from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey
from sqlalchemy.sql import func
from core.db import Base

class Food(Base):
    __tablename__ = "foods"
    food_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    food_category_id = Column(Integer, ForeignKey("categories.category_id"), nullable=False)
    food_name = Column(String, nullable=False)
    food_description = Column(String, nullable=False)
    food_price = Column(Float, nullable=False)
    is_available = Column(Boolean, default=True)
    created_at = Column(String, default=func.now())
