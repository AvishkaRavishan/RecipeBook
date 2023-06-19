//
//  ContentView.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = FirebaseManager()
    @State private var searchText = ""
    @State private var searchResults: [Recipe] = []

    var body: some View {
        TabView {
            RecipeListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Recipes")
                }
            
            SearchView(searchText: $searchText, searchResults: $searchResults)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Add Recipe")
                }

        }
        .onAppear {
            recipeViewModel.fetchRecipes()
        }
    }
}
