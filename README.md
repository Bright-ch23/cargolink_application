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

