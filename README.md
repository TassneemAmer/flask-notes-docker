# Flask Notes App — Docker Compose

A simple note-taking web application built with **Python (Flask)** and **MySQL**, containerized using **Docker** and orchestrated with **Docker Compose**.

The project provides a fully reproducible development environment that can be started with a single command.

## 🚀 Features

* Web UI to add and view notes
* REST API to create and list notes
* Notes stored persistently in MySQL
* Health check endpoint for readiness
* Docker Compose orchestration
* Environment-based configuration
* Non-root web container

---

## 🛠 Technologies Used

* Python 3.10+
* Flask
* MySQL 8.x
* Docker
* Docker Compose v2

---

## 📁 Project Structure

.
├── app/
│   ├── app.py
│   ├── templates/
│   │   └── index.html
│   └── static/
├── db/
│   └── init/
│       └── 01_init.sql
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example
├── .env            # local only, not committed
└── README.md

---

## ⚙️ Configuration

All configuration is done using environment variables.

A sample file is provided:

.env.example

To run the project locally, create a `.env` file based on `.env.example`:

```env
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=notesdb
MYSQL_USER=notesuser
MYSQL_PASSWORD=notespassword

DB_HOST=db
DB_NAME=notesdb
DB_USER=notesuser
DB_PASSWORD=notespassword
```

> ⚠️ Do not commit the `.env` file.

## ▶️ How to Run the Application

### Prerequisites

* Docker Desktop installed and running
* Docker Compose v2

### Start the stack

```bash
docker compose up --build
```

This will:

* Start a MySQL container
* Initialize the database and tables
* Start the Flask web application

### Access the app

Open your browser and go to:

<http://localhost:8080>

---

## 🧪 Testing the Application

### Web UI

1. Open the homepage
2. Enter a note (e.g., “Buy milk”)
3. Click **Add Note**
4. The note appears in the list (most recent first)

---

### API Endpoints

#### Create a note

```bash
curl -X POST http://localhost:8080/notes \
  -H "Content-Type: application/json" \
  -d '{"content":"Buy milk"}'
```

Response:

```json
{
  "message": "Note created"
}
```

---

#### List notes

```bash
curl http://localhost:8080/notes
```

Response example:

```json
[
  {
    "id": 1,
    "content": "docker project check",
    "created_at": "2026-02-16 23:44:45"
  }
]
```

---

#### Health check

```bash
curl http://localhost:8080/healthz
```

Returns `200 OK` only when the database is reachable.

---

## 💾 Data Persistence

MySQL data is stored in a **named Docker volume**.

Stopping and restarting containers will **not** delete notes.

---

## 🧹 How to Stop and Clean Up

### Stop containers

```bash
docker compose down
```

### Stop and remove database data

```bash
docker compose down -v
```

> ⚠️ This will delete all stored notes.

---

## 🔐 Security Notes

* No secrets are committed to the repository
* All credentials are injected via environment variables
* The Flask container runs as a **non-root user**

---

## 🧩 Architecture Overview

Browser
   |
   v
Flask Web App (container: web)
   |
   v
MySQL Database (container: db)
   |
   v
Named Docker Volume (persistent storage)

---

## ✅ Acceptance Criteria Coverage

* One-command startup ✔
* Persistent MySQL storage ✔
* Health checks implemented ✔
* Environment-based configuration ✔
* Non-root web container ✔
* Clear documentation ✔

---

## 📌 Notes

This project is intended as a **development setup** using Docker Compose.
It is not deployed to the internet and does not include production hardening.

---

## 👤 Author

Tassneem Amer
