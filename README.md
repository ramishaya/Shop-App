#  Shops App

A Flutter technical assessment app that displays a list of grocery stores using the provided API.

## Features

- Display shops list
- Shop card includes:
  - Cover photo
  - Shop name
  - Shop description
  - Estimated delivery time
  - Minimum order
  - Location
  - Availability badge
- Debounced search by name or description
- Sort by ETA (ascending)
- Sort by minimum order (ascending)
- Filter between **All** and **Open only**
- Clear filters
- Loading, error, and no-results states
- Pull to refresh
- Light / dark mode

## Architecture

This project uses:

- **Flutter Bloc / Cubit** for state management
- **Repository pattern**
- **Dio** for networking
- **GetIt** for dependency injection
- **GoRouter** for routing

The structure is feature-based and separated into:

- `core`
- `features/shops/data`
- `features/shops/presentation`

## Setup Instructions

### 1. Clone the project


git https://github.com/ramishaya/Shop-App.git
cd shop_app