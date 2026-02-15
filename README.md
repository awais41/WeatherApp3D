🌤 WeatherApp3D
AI-Assisted, Production-Structured Flutter Application

A modular Flutter weather application built using Clean Architecture, BLoC, and strict engineering constraints — developed as an exploration of Codex 5.3 as an architectural assistant.

⚡ Built in ~5 hours
🤖 100% AI-generated code under structured constraints
🏗 Designed to simulate production-level architecture

🎯 Project Intent

This is not just a weather app.

This project was created to evaluate:

How AI performs under real architectural constraints

Whether AI can respect separation of concerns

How well it handles async race conditions

Its ability to refactor without breaking boundaries

Its performance in modular scalable setups

The focus was engineering discipline — not feature complexity.

🏗 Architecture Overview

The project follows strict Clean Architecture principles.

lib/
 ├── core/
 │    ├── constants/
 │    ├── network/
 │    ├── utils/
 │    └── di/
 │
 ├── features/
 │    ├── weather/
 │    │     ├── data/
 │    │     ├── domain/
 │    │     └── presentation/
 │    │
 │    ├── city_search/
 │
 └── main.dart
🧱 Layer Responsibilities
Presentation Layer

BLoC state management

UI rendering

Animation handling

Sensor interaction

Strict one-file-one-class rule

Domain Layer

Pure business logic

Entities

Repository contracts

Use cases

Data Layer

Remote APIs (OpenWeather)

Geocoding service (Open-Meteo)

Local persistence (SharedPreferences)

Model → Entity mapping

🔄 State Flow (Simplified)
UI → Event → BLoC → UseCase → Repository → DataSource → API
                                            ↓
                                    Entity → State → UI

Race-condition handling implemented using:

Request versioning

Source priority (manual vs location)

Async result invalidation

✨ Key Engineering Highlights
🧠 Async Safety

Manual city selection cannot be overridden by late location responses
(Request versioning implemented inside BLoC)

🌗 Intelligent Icon System

Uses OpenWeather icon code (01d / 01n)

Custom asset naming support

Day/Night switching logic

🌅 Dynamic Sunrise → Sunset System

Progress calculation based on solar time

Animated sun/moon indicator

Gradient sky interpolation

📍 Smart Location Handling

Auto-load by current location

Manual override priority

Offline fallback support

🧩 Feature-Based Modularity

Weather and City Search are independent modules.

🌍 APIs & Services

OpenWeather API (Weather data)

Open-Meteo Geocoding API (Free city search)

Geolocator (device location)

sensors_plus (tilt interaction)

⚙️ Tech Stack

Flutter

BLoC

Dio

GetIt (Dependency Injection)

SharedPreferences

Clean Architecture

Feature-based modular design

🚀 Getting Started
Clone
git clone https://github.com/awais41/WeatherApp3D.git
cd WeatherApp3D
Install Dependencies
flutter pub get
Add OpenWeather API Key

Inside:

lib/core/constants/api_constants.dart

Insert your API key.

Run
flutter run
🤖 AI-Assisted Development

This application was generated using Codex 5.3, but under strict constraints:

One file = one class

No logic in UI

Repository pattern enforced

Async race-condition handling required

Modular feature separation mandatory

The experiment demonstrates:

AI is not just a snippet generator —
it can assist in structured architectural workflows when guided correctly.


📈 Why This Project Matters

This project demonstrates:

Architectural thinking

Scalable project structuring

AI-guided engineering workflow

Rapid prototyping under constraints

Clean separation of concerns

Async debugging and resolution

For recruiters and engineers reviewing this repository:![Media](https://github.com/user-attachments/assets/b51f92a4-b804-4205-b9cc-132430224271)
![Media (3)](https://github.com/user-attachments/assets/7f6e9494-8e97-4ef5-be84-bede039e6cd7)
![Media (2)](https://github.com/user-attachments/assets/d37ed411-bca9-4ca1-adc6-7ed2499f3909)
![Media (1)](https://github.com/user-attachments/assets/e748ff85-d4b0-44de-bb64-bc9f989d484f)

This is a demonstration of engineering structure, not just UI implementation.
