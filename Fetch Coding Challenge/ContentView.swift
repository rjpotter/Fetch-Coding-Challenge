//
//  ContentView.swift
//  Fetch Coding Challenge
//
//  Created by Ryan Potter on 7/15/24.
//

import SwiftUI

struct ContentView: View, Sendable {
    @State private var meals: [Meal] = []
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if meals.isEmpty {
                    ProgressView("Loading Desserts...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onAppear {
                            Task {
                                await fetchMeals()
                            }
                        }
                } else {
                    List(meals) { meal in
                        NavigationLink(destination: RecipeView(mealId: meal.id)) {
                            HStack {
                                AsyncImage(url: URL(string: meal.thumbnail)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                                Text(meal.name)
                                    .font(.headline)
                                    .padding(.leading, 10)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .navigationTitle("Desserts")
                }
            }
        }
    }

    private func fetchMeals() async {
        do {
            let fetchedMeals = try await MealAPI.fetchDessertMeals()
            meals = fetchedMeals.sorted { $0.name < $1.name }
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching meals: \(errorMessage!)")
        }
    }
}


#Preview {
    ContentView()
}

