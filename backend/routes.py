from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from database import db
from bson.objectid import ObjectId
from datetime import datetime
import json
from models import User, ShoppingItem 

router = APIRouter()


@router.post("/register")
def register(user: User):
    result = db.users.insert_one({
        "name": user.name,
        "email": user.email,
        "created_at": datetime.utcnow()
    })
    return {
        "message": "User registered",
        "user_id": str(result.inserted_id)  

    }

@router.get("/shopping-items/{user_id}")
def get_items(user_id: str):
    try:
        ObjectId(user_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid user ID format")

    items = list(db.items.find({"user_id": user_id}))
    for item in items:
        item["_id"] = str(item["_id"])
    return items



@router.post("/shopping-items")
def add_item(item: ShoppingItem):
    if not item.user_id or not item.title:
        raise HTTPException(status_code=400, detail="Missing required fields")
    
    db.items.insert_one({
        **item.dict(),
        "created_at": datetime.utcnow()
    })
    return {"message": "Predefined item added"}




@router.post("/shopping-items/custom")
def add_custom_item(item: ShoppingItem):
    user_id = item.user_id
    
    if '@' in user_id:
        user = db.users.find_one({"email": user_id})
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        item.user_id = str(user["_id"])

    item_dict = item.dict()
    item_dict["created_at"] = datetime.utcnow()
    db.items.insert_one(item_dict)
    return {"message": "Custom item added"}



@router.put("/shopping-items/{item_id}")
def update_item(item_id: str, item: ShoppingItem):
    try:
        obj_id = ObjectId(item_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid item ID format")

    updated_data = item.dict()

    result = db.items.update_one(
        {"_id": obj_id},
        {"$set": updated_data}
    )

    if result.modified_count == 1:
        return {"message": "Item updated"}
    
    raise HTTPException(status_code=404, detail="Item not found")



@router.delete("/shopping-items/{item_id}")
def delete_item(item_id: str):
    try:
        obj_id = ObjectId(item_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid item ID format")

    result = db.items.delete_one({"_id": obj_id})
    if result.deleted_count == 1:
        return {"message": "Item deleted"}
    raise HTTPException(status_code=404, detail="Item not found")





@router.get("/predefined-items")
def get_predefined_items():
    try:
        with open("predefined_items.json") as f:
            return json.load(f)
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Predefined items file not found")

@router.get("/users")
def get_users():
    users = list(db.users.find())
    for u in users:
        u["_id"] = str(u["_id"])
    return users
