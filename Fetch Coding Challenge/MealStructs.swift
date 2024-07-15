//
//  MealAPI.swift
//  Fetch Coding Challenge
//
//  Created by Ryan Potter on 7/15/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}

struct MealResponse: Codable {
    let meals: [Meal]
}

struct MealAPI {
    static func fetchDessertMeals() async throws -> [Meal] {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // Print raw data for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }

        let response = try JSONDecoder().decode(MealResponse.self, from: data)

        return response.meals
    }
}
