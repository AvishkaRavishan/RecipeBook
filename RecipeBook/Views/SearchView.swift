//
//  SearchView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    @Binding var searchResults: [Recipe]
    @StateObject private var recipeViewModel = FirebaseManager()

    var body: some View {
        VStack {
            if searchResults.isEmpty {
                Spacer()
                Text("No recipes found")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(searchResults, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                            Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(GroupedListStyle())
            }

            Spacer()

            TextField("Search Recipes", text: $searchText)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 16)

            Button(action: {
                recipeViewModel.searchRecipes(with: searchText) { recipes in
                    searchResults = recipes
                }
            }) {
                Text("Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 16)
        }
        .padding()
        .navigationBarTitle("Search Recipes")
        .onAppear {
            recipeViewModel.fetchRecipes()
        }
    }
}
