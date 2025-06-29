# from pydantic import BaseModel

# class User(BaseModel):
#     name: str
#     email: str

# class ShoppingItem(BaseModel):
#     user_id: str
#     title: str
#     repeat_interval: str  # e.g., weekly, monthly
#     reminder_time: str    # e.g., 09:00
#     type: str = "custom"  # custom or predefined
#     status: str = "pending"
#     reminder_enabled: bool = True

# # backend/predefined_items.json
# [
#   {
#     "title": "Restock groceries",
#     "repeat_interval": "weekly",
#     "reminder_time": "10:00",
#     "type": "predefined"
#   },
#   {
#     "title": "Buy cleaning supplies",
#     "repeat_interval": "monthly",
#     "reminder_time": "11:00",
#     "type": "predefined"
#   },
#   {
#     "title": "Order personal care products",
#     "repeat_interval": "monthly",
#     "reminder_time": "12:00",
#     "type": "predefined"
#   }
# ]

# backend/models.py

from pydantic import BaseModel
from typing import Optional



# ----------------- Models ------------------

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

