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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let mealDetail = mealDetail {
                    AsyncImage(url: URL(string: mealDetail.thumbnail)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    Text(mealDetail.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                        .padding(.horizontal)

                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(mealDetail.ingredients.sorted(by: >), id: \.key) { key, value in
                            HStack {
                                Text(key)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(value)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                    }

                    Divider()
                        .padding(.horizontal)

                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    Text(mealDetail.instructions)
                        .padding([.horizontal, .bottom])
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ProgressView("Loading Meal Details...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onAppear {
                            Task {
                                await fetchMealDetail()
                            }
                        }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
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
