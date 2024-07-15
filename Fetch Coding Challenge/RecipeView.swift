//
//  RecipeView.swift
//  Fetch Coding Challenge
//
//  Created by Ryan Potter on 7/15/24.
//

import SwiftUI

struct RecipeView: View {
    let mealId: String
    @State private var mealDetail: MealDetail?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let mealDetail = mealDetail {
                Text(mealDetail.name)
                    .font(.largeTitle)
                    .padding()
                Text(mealDetail.instructions)
                    .padding()

                List {
                    ForEach(mealDetail.ingredients.sorted(by: >), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text(value)
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await fetchMealDetail()
                        }
                    }
            }
        }
        .navigationTitle("Meal Details")
    }

    private func fetchMealDetail() async {
        do {
            let detail = try await MealAPI.fetchMealDetails(by: mealId)
            mealDetail = detail
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching meal details: \(errorMessage!)")
        }
    }
}
