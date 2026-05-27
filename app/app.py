from flask import Flask, request, jsonify, render_template, redirect, url_for
import os
import mysql.connector

app = Flask(__name__)

# -----------------------------
# Database connection helper
# -----------------------------
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )

# -----------------------------
# Health check endpoint
# -----------------------------
@app.route("/healthz")
def healthz():
    try:
        conn = get_db_connection()
        conn.close()
        return {"status": "ok"}, 200
    except Exception as e:
        return {"status": "error", "message": str(e)}, 500

# -----------------------------
# Fetch all notes helper
# -----------------------------
def fetch_all_notes():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT id, content, created_at FROM notes ORDER BY created_at DESC"
    )
    notes = cursor.fetchall()
    cursor.close()
    conn.close()
    return notes

# -----------------------------
# API: list notes (JSON)
# -----------------------------
@app.route("/notes", methods=["GET"])
def list_notes():
    notes = fetch_all_notes()
    return jsonify(notes), 200

# -----------------------------
# API: create note (JSON)
# -----------------------------
@app.route("/notes", methods=["POST"])
def create_note():
    data = request.get_json()
    content = data.get("content") if data else None

    if not content or not content.strip():
        return {"error": "Note content cannot be empty"}, 400

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO notes (content) VALUES (%s)",
        (content.strip(),)
    )
    conn.commit()
    cursor.close()
    conn.close()

    return {"message": "Note created"}, 201

# -----------------------------
# Web UI: homepage (POST → Redirect → GET)
# -----------------------------
@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        content = request.form.get("content")

        if content and content.strip():
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO notes (content) VALUES (%s)",
                (content.strip(),)
            )
            conn.commit()
            cursor.close()
            conn.close()

        return redirect(url_for("index"))

    notes = fetch_all_notes()
return render_template(
    "index.html",
    notes=notes,
    deployment_message="🔥 AUTO CI/CD DEPLOYMENT SUCCESSFUL 🔥"
)
# -----------------------------
# App entry point
# -----------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
