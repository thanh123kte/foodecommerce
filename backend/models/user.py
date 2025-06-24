from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    full_name = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    address = Column(String, nullable=True)
    day_of_birth = Column(String, nullable=True)  # ISO string, hoặc dùng Date nếu muốn
    role = Column(String, default="1")
    avatar_url = Column(String, nullable=True)
    status = Column(String, nullable=True)
    created_at = Column(DateTime, default=func.now())
