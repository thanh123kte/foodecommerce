from pydantic_settings import BaseSettings, SettingsConfigDict
import os

class Settings(BaseSettings):
    SECRET_KEY: str = "your_secret_key" # Nên lấy từ biến môi trường
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    model_config = SettingsConfigDict(env_file=".env", extra='ignore')

settings = Settings()