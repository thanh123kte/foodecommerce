from sqlalchemy import Column, Integer, String
from core.db import Base

class Category(Base):
    __tablename__ = "categories"
    category_id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String, unique=True, nullable=False)
    category_icon_url = Column(String, nullable=True)
