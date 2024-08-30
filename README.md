# mkodo-draws

# Lottery Draws and Tickets SwiftUI App

## Introduction

This project is a SwiftUI-based application that displays lottery draw results and allows users to view their lottery tickets. The app uses a mock data service to fetch lottery draws, organizes them by game, and shows whether the user's ticket is a winner. It features a clean and modular architecture, separating UI, data management, and service layers.

## Approach

### Goal

The primary goal of this project was to create a simple yet efficient SwiftUI application that:
- Fetches and displays lottery draw results.
- Organizes draws by game.
- Allows users to view their ticket numbers and check if they have won.

### Strategy

1. **Data Management**: 
    - Implemented a `DataManager` class to handle caching of draw results using `UserDefaults`. This ensures quick access to data and provides offline functionality.

2. **Mock Service**:
    - Used a `MockDrawsService` to simulate network requests for fetching draw data. This is crucial for testing and developing the app without needing an active network connection.

3. **View Models**:
    - Created `DrawsViewModel` and `MyTicketsViewModel` to handle the business logic and data transformations necessary for displaying the information in SwiftUI views.

4. **UI Implementation**:
    - Built a set of SwiftUI views that leverage the view models to present data to the user, including organized draw lists and detailed ticket information.

## Technology Choices

### 1. **SwiftUI**
SwiftUI was chosen for its declarative syntax and efficient state management, making it easier to build and preview user interfaces.

### 2. **Combine**
Combine was used to handle asynchronous data flows between the service layer, view models, and SwiftUI views.

### 3. **UserDefaults**
`UserDefaults` was utilized for its simplicity in storing small amounts of user-specific data like cached draw results.

### 4. **Mock Services**
A mock service (`MockDrawsService`) was employed to simulate fetching data from an external source. This choice facilitates local development and testing.

### 5. **Protocols**
Protocols (`DrawsViewModelType`, `DataManagerType`) were used to define clear contracts between components, enhancing testability and promoting dependency injection.

## Testing
The app uses the mock service for data, so it can be tested on any device without requiring network access.


## Project Structure

```plaintext
LotteryApp/
├── Models/
│   ├── Draw.swift
│   ├── DrawServiceError.swift
│   └── MockDrawsService.swift
├── ViewModels/
│   ├── DrawsViewModel.swift
│   ├── MyTicketsViewModel.swift
│   └── DrawDetailViewModel.swift
├── Views/
│   ├── DrawsView.swift
│   ├── MyTicketsView.swift
│   ├── DrawDetailView.swift
│   ├── WinningBannerView.swift
│   └── TicketNumbersGridView.swift
├── Managers/
│   └── DataManager.swift
├── Resources/
│   └── Assets.xcassets
├── SupportingFiles/
│   └── Info.plist
└── LotteryApp.swift
