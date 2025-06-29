

from pydantic import BaseModel
from typing import Optional




class User(BaseModel):
    name: str
    email: str

class ShoppingItem(BaseModel):
    user_id: str
    title: str
    repeat_interval: str
    reminder_time: str
    type: str = "custom"
    status: str = "pending"
    reminder_enabled: bool = True


# class ShoppingItem(BaseModel):
#     user_id: str
#     title: str
#     repeat_interval: str
#     reminder_time: str
#     type: str = "custom"  # "custom" or "predefined"

