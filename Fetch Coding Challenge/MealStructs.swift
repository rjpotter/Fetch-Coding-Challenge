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

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
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
    
    static func fetchMealDetails(by id: String) async throws -> MealDetail {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!

        let (data, _) = try await URLSession.shared.data(from: url)

        // Print raw data for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }

        do {
            let response = try JSONDecoder().decode(MealDetailResponse.self, from: data)
            guard let mealDetail = response.meals.first else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Meal details not found"])
            }
            return mealDetail
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}

struct MealDetail: Codable {
    let id: String
    let name: String
    let instructions: String
    let thumbnail: String
    let ingredients: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
    }
    
    // Custom decoding to handle dynamic keys for ingredients and measurements
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)

        // Handle dynamic keys for ingredients and measurements
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredientsDict = [String: String]()

        for key in dynamicContainer.allKeys {
            if key.stringValue.starts(with: "strIngredient") {
                let ingredientKey = key.stringValue
                let measureKey = ingredientKey.replacingOccurrences(of: "strIngredient", with: "strMeasure")

                if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: key),
                   !ingredient.isEmpty,
                   let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: measureKey)!),
                   !measure.isEmpty {
                    ingredientsDict[ingredient] = measure
                }
            }
        }

        ingredients = ingredientsDict
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }
}
