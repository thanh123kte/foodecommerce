from sqlalchemy import Column, Integer, String, Float, Boolean
from sqlalchemy.sql import func
from core.db import Base

class Shop(Base):
    __tablename__ = "shops"
    shop_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False)
    shop_name = Column(String, nullable=False)
    shop_description = Column(String, nullable=True)
    shop_image_url = Column(String, nullable=True)
    rating = Column(Float, default=0.0)
    location = Column(String, nullable=True)
    is_favorite = Column(Boolean, default=False)
    is_available = Column(Boolean, default=True)
    created_at = Column(String, default=func.now())
