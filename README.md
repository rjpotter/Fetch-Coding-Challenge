# Dessert Recipes App

## Overview

The Dessert Recipes App is a native iOS application that allows users to browse and view details of various dessert recipes. The app fetches data from TheMealDB API and displays a list of desserts. Users can tap on any dessert to see detailed information, including ingredients and instructions.

## Features

- Fetches and displays a list of dessert recipes from TheMealDB API.
- Displays detailed information about each dessert, including ingredients and instructions.
- User-friendly and attractive UI with async image loading and smooth navigation.

## API

The app utilizes the following endpoints from TheMealDB API:

1. **Fetch Dessert Meals**
   - Endpoint: `https://themealdb.com/api/json/v1/1/filter.php?c=Dessert`
   - Description: Retrieves a list of meals in the Dessert category.

2. **Fetch Meal Details**
   - Endpoint: `https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID`
   - Description: Retrieves detailed information about a meal by its ID.

## Development Process

### Setup and Dependencies

1. **Xcode**: Used the latest version of Xcode.
2. **SwiftUI**: The app is built using SwiftUI, leveraging the latest features for UI design and data handling.
3. **Swift Concurrency**: Asynchronous code is written using `async/await` for efficient network requests and data fetching.

### Key Components

1. **Models**
   - `Meal`: Represents a meal with its basic details (id, name, thumbnail).
   - `MealDetail`: Represents detailed information about a meal, including ingredients and instructions.
   - `MealResponse`: Represents the response structure for fetching meals.
   - `MealDetailResponse`: Represents the response structure for fetching meal details.

2. **API Layer**
   - `MealAPI`: Contains methods for fetching dessert meals and meal details using `URLSession` and `async/await`.

3. **Views**
   - `ContentView`: Displays a list of dessert meals. Fetches data from the API and handles loading and error states.
   - `RecipeView`: Displays detailed information about a selected meal. Fetches data from the API and handles loading and error states.

### UI Design

The app's UI is designed to be user-friendly and visually appealing:
- **AsyncImage**: Used for loading and displaying images asynchronously.
- **ProgressView**: Displayed while data is being fetched from the API.
- **NavigationLink**: Enables navigation from the list of meals to detailed views.
- **VStack** and **HStack**: Used for organizing UI elements in a vertical and horizontal layout, respectively.
- **Padding and Spacing**: Applied to ensure a clean and organized layout.

### Error Handling

The app includes basic error handling to display appropriate messages to the user if data fetching fails or if there are any issues with the API requests.
