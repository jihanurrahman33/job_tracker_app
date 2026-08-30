# 💼 Job Tracker Mobile App

A production-ready Flutter mobile application for tracking job applications, scheduling interview rounds, setting follow-up reminders, and monitoring key career pipeline metrics.

Built with **Flutter Clean Architecture** and **Feature-First modularization**.

---

## 📱 App Highlights & Features

- 🔐 **Authentication & Session Persistence**: Register, login, session restore on app launch (`/api/v1/me`), auto bearer header injection and offline profile fallback.
- 📊 **Dashboard & Metrics Analytics**: KPI cards showing Response Rate (%), Interview Rate (%), and Offer Rate (%), with multi-segment pipeline status progress bars and quick actions.
- 📝 **Application Tracking & Management**:
  - Full CRUD operations on job applications.
  - Search by company, role, or location.
  - Status filter bottom sheet.
  - Status history timeline (`/events`).
  - Pagination and pull-to-refresh.
- 📅 **Interview Scheduling**:
  - Schedule technical, behavioral, system design, HR, and phone screen rounds.
  - Meeting URL with one-tap clipboard copy.
  - Duration and location details.
- ⏰ **Tasks & Follow-up Reminders**:
  - Follow-up reminders linked to specific applications.
  - Status toggle (completed vs pending).
  - Overdue badge indicators.
- ⚙️ **Settings & Server Switcher**:
  - Switch dynamically between **Render** (`https://job-tracker-server-9drb.onrender.com`), **Vercel** (`https://job-tracker-server-nu.vercel.app`), **Localhost** (`http://localhost:8080`), or Custom URLs.
  - Toggle between System Default, Light Mode, and Dark Mode.

---

## 🏗️ Architecture & Project Structure

The project strictly follows the Flutter Clean Architecture standard:

```text
lib/
├── core/
│   ├── app/                      # GoRouter declarative navigation & ShellRoute
│   ├── constants/                # API endpoints and status constants
│   ├── error/                    # Domain Failures & Data Exceptions
│   ├── extensions/               # Date, String, and Context extensions
│   ├── networking/               # ApiClient (HTTP with bearer auth & error mapping)
│   ├── theme/                    # Material 3 Light & Dark themes
│   ├── usecases/                 # Base UseCase and NoParams
│   ├── utils/                    # Either<Failure, Success> monad & Validators
│   └── widgets/                  # Reusable UI primitives (Buttons, Inputs, Badges)
│
├── features/
│   ├── auth/                     # Authentication & Token Management
│   ├── application/              # Applications & Event Timelines
│   ├── interview/                # Interview Rounds & Scheduling
│   ├── reminder/                 # Follow-ups & Reminders
│   ├── dashboard/                # Analytics & Aggregated Statistics
│   └── settings/                 # Server URL & Theme Configuration
│
├── injection_container.dart        # Service locator orchestrator (GetIt)
└── main.dart                     # App bootstrap & MultiBlocProvider
```

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Static Analysis & Tests
```bash
flutter analyze
flutter test
```

### 3. Launch App
```bash
flutter run
```

