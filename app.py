from flask import Flask, request, jsonify
from pymongo import MongoClient
import os

app = Flask(__name__)

# MongoDB URI from env var or default to localhost (for dev)
mongo_uri = os.environ.get("MONGO_URI", "mongodb://localhost:27017/")
client = MongoClient(mongo_uri)
db = client["devops"]
collection = db["items"]

@app.route("/", methods=["GET"])
def home():
    return "Flask MongoDB DevOps API is running"

@app.route("/add", methods=["POST"])
def add_item():
    data = request.json
    if not data or "name" not in data:
        return jsonify({"error": "Missing 'name'"}), 400
    item_id = collection.insert_one({"name": data["name"]}).inserted_id
    return jsonify({"message": "Item added", "id": str(item_id)}), 201

@app.route("/items", methods=["GET"])
def get_items():
    items = [{"id": str(doc["_id"]), "name": doc["name"]} for doc in collection.find()]
    return jsonify(items)

@app.route("/delete/<string:item_name>", methods=["DELETE"])
def delete_item(item_name):
    result = collection.delete_one({"name": item_name})
    if result.deleted_count:
        return jsonify({"message": f"Deleted item: {item_name}"}), 200
    return jsonify({"error": "Item not found"}), 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
