//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var recipeViewModel = FirebaseManager()
    @State private var newRecipeTitle = ""
    @State private var newRecipeIngredient = ""
    @State private var newRecipeIngredients: [String] = []
    @State private var newRecipeInstructions = ""
    @State private var newRecipeImageURL = ""
    @State private var showError = false
    @State private var showSuccess = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Title", text: $newRecipeTitle)
                        .font(.headline)
                        .padding(.vertical, 8)

                    TextField("Image URL", text: $newRecipeImageURL)
                        .font(.headline)
                        .padding(.vertical, 8)

                    Text("Ingredients")
                        .font(.headline)
                        .padding(.top)

                    VStack(alignment: .leading) {
                        ForEach(newRecipeIngredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }

                        HStack {
                            TextField("Add Ingredient", text: $newRecipeIngredient)
                                .font(.headline)
                                .padding(.vertical, 8)

                            Button(action: {
                                addIngredient()
                            }, label: {
                                Text("Add")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            })
                            .disabled(newRecipeIngredient.isEmpty)
                        }
                    }
                    .padding(.vertical, 8)

                    Text("Instructions")
                        .font(.headline)
                        .padding(.top)

                    TextEditor(text: $newRecipeInstructions)
                        .frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.vertical, 8)
                }

                Section {
                    Button(action: {
                        addRecipe()
                    }, label: {
                        Text("Add Recipe")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .listRowBackground(Color.blue)
                    .disabled(newRecipeTitle.isEmpty || newRecipeIngredients.isEmpty)
                }
            }
            .navigationBarTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Recipe title is required."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showSuccess) {
                Alert(title: Text("Success"), message: Text("Recipe added successfully."), dismissButton: .default(Text("OK")) {
                    navigateBack()
                })
            }
        }
    }

    private func addIngredient() {
        let ingredient = newRecipeIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !ingredient.isEmpty {
            newRecipeIngredients.append(ingredient)
            newRecipeIngredient = ""
        }
    }

    private func addRecipe() {
        guard !newRecipeTitle.isEmpty else {
            showError = true
            return
        }

        let recipe = Recipe(
            id: UUID().uuidString,
            title: newRecipeTitle,
            ingredients: newRecipeIngredients,
            instructions: newRecipeInstructions,
            imageURL: URL(string: newRecipeImageURL)
        )

        recipeViewModel.addRecipe(recipe)

        showSuccess = true
        
        // Clear the fields
        newRecipeTitle = ""
        newRecipeIngredient = ""
        newRecipeIngredients = []
        newRecipeInstructions = ""
        newRecipeImageURL = ""
    }

    private func navigateBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
