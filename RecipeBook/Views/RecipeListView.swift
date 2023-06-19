//
//  RecipeListView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct RecipeListView: View {
    @ObservedObject private var recipeViewModel = FirebaseManager()
    @State private var selectedRecipe: Recipe?
    @State private var isEditingRecipe = false

    var body: some View {
        NavigationView {
            List {
                ForEach(recipeViewModel.recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        HStack {
                            if let imageURL = recipe.imageURL {
                                WebImage(url: imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(5)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(30)
                            }

                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                Text("Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Instructions: \(recipe.instructions)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button(action: {
                            // Navigate to EditRecipeView
                            selectedRecipe = recipe
                            isEditingRecipe = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else {
                        return
                    }
                    let recipeToDelete = recipeViewModel.recipes[index]
                    recipeViewModel.deleteRecipe(recipeToDelete) { error in
                        if let error = error {
                            // Handle the error
                            print("Error deleting recipe: \(error.localizedDescription)")
                        } else {
                            // Recipe deleted successfully
                            recipeViewModel.fetchRecipes() // Refresh the recipe list
                        }
                    }
                }
                .onMove { indices, newOffset in
                    recipeViewModel.recipes.move(fromOffsets: indices, toOffset: newOffset)
                    // TODO: Update the order of recipes in Firebase or perform any necessary actions
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $selectedRecipe) { recipe in
                NavigationView {
                    EditRecipeView(recipe: recipe)
                        .navigationBarItems(leading: Button("Cancel") {
                            isEditingRecipe = false
                            selectedRecipe = nil
                        })
                }
            }
            .onAppear {
                recipeViewModel.fetchRecipes()
            }
            .navigationTitle("Recipes")
        }
    }
}
