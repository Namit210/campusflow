# CampusFlow

### A Flutter Mobile Application for Programme Discovery and Registration

CampusFlow is a mobile application developed by Team 5 as part of the Excelerate Mobile App Development with Flutter internship. The application allows users to explore available programmes, view programme details and complete registration forms through a simple mobile interface.

## 1. Project Purpose

The purpose of CampusFlow is to provide users with an accessible platform for discovering programmes and accessing relevant programme information. It brings programme listings, programme details and registration functionality together in one mobile application.

## 2. Key Features

- **Login Screen:** Provides the application's login interface.
- **Home Screen:** Provides access to the application's main features.
- **Programme Listing:** Displays programme information retrieved through the connected API.
- **Programme Details:** Allows users to view information about selected programmes.
- **Registration Form:** Allows users to enter and submit their registration details.
- **Backend Integration:** Connects the application to a backend service linked to MongoDB.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Application programming language |
| REST API | Retrieving programme information and communicating with the backend |
| MongoDB | Backend database |
| GitHub | Source code management and team collaboration |

## 4. Data Integration

CampusFlow retrieves programme information through a connected API. The application displays the returned information on the Programme Listing screen. Users can select a programme to view its details.

The backend is connected to MongoDB for data management. The application also provides a registration form through which users can enter and submit their details.

## 5. Application Screenshots

The following screenshots demonstrate the main application interfaces:

### Login Screen
![Login Screen](screenshots/login.png)

### Home Screen
![Home Screen](screenshots/home.png)

### Programme Listing
![Programme Listing](screenshots/program-listing.png)

### Programme Details
![Programme Details](screenshots/program-details.png)

### Registration Form
![Registration Form](screenshots/registration-form.png)

### Form Submission Result
![Form Submission Result](screenshots/submission-result.png)

## 6. Getting Started

### Prerequisites

Before running the application, ensure that you have:

- Flutter SDK installed.
- Dart SDK available through Flutter.
- Git installed.
- An Android emulator or a compatible mobile device.

### Installation

Clone the repository:

```bash
git clone https://github.com/SyedMukhtar11/campusflow.git
```

Navigate to the project directory:

```bash
cd campusflow
```

Install the project dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

**Note:** The application requires the configured backend API to be accessible for live programme data. Backend-specific setup instructions should be followed when running the backend locally.

## 7. Demo and Deployment

**Live Application:** 

**Demo Video:** [Watch the CampusFlow application walkthrough](https://drive.google.com/file/d/1rkmph5Jg1ypfj1gmMCUPd4KufYGFiRJW/view?usp=sharing)

## 8. Project Structure

```text
campusflow/
├── android/
├── assets/
│   └── data/
├── backend/
├── ios/
├── lib/
├── linux/
├── macos/
├── postman/
├── test/
└── pubspec.yaml
```

- `lib/` – Flutter application source code.
- `assets/data/` – Application data and assets.
- `backend/` – Backend service files.
- `postman/` – API testing resources.
- `test/` – Application tests.
- `pubspec.yaml` – Flutter project configuration and dependencies.

## 9. Team Members

- Ali Alice
- Afnan Munir
- Amit Chausali
- Syed Mukhtar
- Kamogelo Harry Samotse
- Emmanuel Achenie
- Bhabysen Mahanta
- Noor Ulain

## 10. Contributions and Project History

The team's development activities are tracked through GitHub commits and pull requests.

- [View Commit History](https://github.com/SyedMukhtar11/campusflow/commits/main/)
- [View Pull Requests](https://github.com/SyedMukhtar11/campusflow/pulls)

## 11. Security

Database passwords, API keys, private connection strings and other sensitive configuration details should not be committed to this public repository.
