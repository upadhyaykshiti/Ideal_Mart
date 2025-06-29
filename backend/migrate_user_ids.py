
# migrate_user_ids.py

from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()
client = MongoClient(os.getenv("MONGO_URI"))
db = client["ideal_mart"]

def migrate_user_ids():
    users = list(db.users.find())
    print(f"Found {len(users)} users.")

    updated_count = 0

    for user in users:
        email = user.get("email")
        user_obj_id = str(user["_id"])

        result = db.items.update_many(
            {"user_id": email},
            {"$set": {"user_id": user_obj_id}}
        )

        if result.modified_count > 0:
            print(f"Updated {result.modified_count} items for user: {email}")
            updated_count += result.modified_count

    print(f"✅ Migration complete. Total items updated: {updated_count}")

if __name__ == "__main__":
    migrate_user_ids()
