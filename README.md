# 🚚 CargoLink

![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge&logo=githubactions)
![Flutter](https://img.shields.io/badge/Flutter-Stable-blue?style=for-the-badge&logo=flutter)
![Django](https://img.shields.io/badge/Django-6.0.3-darkgreen?style=for-the-badge&logo=django)
![Hosting](https://img.shields.io/badge/Hosted_on-Render-black?style=for-the-badge&logo=render)

CargoLink is a robust, full-stack logistics and booking application designed to streamline cargo management. Built with a cross-platform mobile frontend and a powerful REST API backend, it enables seamless booking, user ratings, and real-time data synchronization.

---

## ✨ Features

* **📦 Freight & Cargo Booking:** End-to-end booking management system.
* **⭐ User Ratings:** Integrated rating system for bookings and services.
* **📱 Cross-Platform Mobile App:** Smooth, responsive UI built with Flutter for Android and iOS.
* **⚙️ Automated CI/CD:** Fully automated GitHub Actions pipeline for generating Android APKs on push.
* **☁️ Cloud Hosted:** Backend deployed seamlessly on Render with an active PostgreSQL database.

---

## 🛠️ Tech Stack

### Mobile Frontend (`/frontend`)
* **Framework:** Flutter / Dart
* **State Management:** Provider / Riverpod *(Update based on your usage)*
* **Networking:** HTTP Client for REST API consumption

### Backend API (`/backend`)
* **Framework:** Django 6.0.3 & Django REST Framework (DRF)
* **Authentication:** Simple JWT (JSON Web Tokens)
* **Database:** PostgreSQL (via `psycopg2-binary`)
* **Server:** Gunicorn & Whitenoise (for static file management)

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

Ensure you have the following installed on your local machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0+)
* [Python](https://www.python.org/downloads/) (v3.14+)
* [Git](https://git-scm.com/)

---

### 1️⃣ Backend Setup (Django)

1. **Navigate to the backend directory:**
   ```bash
   cd backend

```
 2. **Create and activate a virtual environment:**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
   
   ```
 3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   
   ```
 4. **Apply database migrations:**
   ```bash
   python manage.py migrate
   
   ```
 5. **Run the local development server:**
   ```bash
   python manage.py runserver
   
   ```
   *The API will be available at http://127.0.0.1:8000*
### 2️⃣ Frontend Setup (Flutter)
 1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   
   ```
 2. **Fetch Flutter packages:**
   ```bash
   flutter pub get
   
   ```
 3. **Configure the API URL:**
   Locate your API configuration file in the Flutter code and ensure it points to your local Django server (http://10.0.2.2:8000 for Android emulators) or the live Render URL.
 4. **Run the app:**
   ```bash
   flutter run
   
   ```
## 🤖 CI/CD Pipeline & Automated Builds
This repository utilizes **GitHub Actions** to automate the mobile build process.
Whenever code is pushed to the new_frontend branch, the pipeline automatically:
 1. Provisions an Ubuntu runner with Java 17.
 2. Installs the stable Flutter channel.
 3. Retrieves all dependencies inside the frontend/ directory.
 4. Compiles a fresh app-debug.apk.
 5. Uploads the APK as an accessible Artifact in the GitHub Actions tab.
## 🌐 Live Deployment
 * **Backend API:** Hosted on Render
 * The backend is configured with ALLOWED_HOSTS = ['*'] and django-cors-headers to accept requests from the mobile application.
 * *Note: Render free tier instances spin down after 15 minutes of inactivity. The first request may take ~50 seconds to wake the server.*
## 🤝 Contributing
Contributions, issues, and feature requests are welcome!
 1. Fork the Project
 2. Create your Feature Branch (git checkout -b feature/AmazingFeature)
 3. Commit your Changes (git commit -m 'Add some AmazingFeature')
 4. Push to the Branch (git push origin feature/AmazingFeature)
 5. Open a Pull Request
```

