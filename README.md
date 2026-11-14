
# PureDrop Dairy

A Flutter-based milk delivery tracking application developed as part of the Ezitech Flutter Development Internship.

## Task 1: Core Architecture & Subscription Dashboard

This task focuses on building a scalable application foundation using Clean Architecture and Riverpod dependency injection.

## Features

- Responsive customer dashboard
- Seven days of sample milk delivery records
- Delivered and Pending status badges
- Milk quantity and delivery date
- Active subscription display (mock)
- Loading, error, and empty states
- Reusable Flutter widgets

## Technologies

- Flutter and Dart
- Riverpod
- Google Fonts
- Material Design 3

## Architecture

The application follows three separate layers:

### Domain
Contains delivery entities and repository contracts.

### Data
Contains the mock delivery service, repository implementation, and Riverpod providers.

### Presentation
Contains dashboard screens and reusable UI widgets.

Data flow:

Dashboard -> Riverpod Provider -> DeliveryRepository -> MockDeliveryRepository -> MockDeliveryService

The dashboard does not directly access the mock service.

## Setup

1. Install Flutter SDK.
2. Clone the repository.
3. Open the project directory.
4. Install dependencies:

   flutter pub get

5. Run the Android application:

   flutter run

## Testing

Run static analysis:

   flutter analyze

Run automated tests:

   flutter test

## Deployment

For an Android release build:

   flutter build apk --release

The generated APK can be found in:

   build/app/outputs/flutter-apk/app-release.apk

Production deployment requires app signing and release configuration.

## Technical Decision Log

### Why Riverpod?

Riverpod was selected for dependency injection and asynchronous state management.

The repository provider is declared in the data layer and exposes the domain repository contract.

This allows the mock repository to be replaced by an offline persistence implementation without rewriting the dashboard.

### Why Clean Architecture?

Clean Architecture separates business logic from Flutter widgets, improves testability, and supports future features.

### Why ListView.builder?

ListView.builder efficiently creates visible delivery cards and supports scalable lists.

### Why MediaQuery?

MediaQuery provides screen dimensions in logical pixels, helping adapt the layout to different screen sizes and densities.

## Future Tasks

Task 2: Offline-first data persistence.

Task 3: Security review and final handover.

## Author

Asad Bajwa

Ezitech Flutter Development Internship
