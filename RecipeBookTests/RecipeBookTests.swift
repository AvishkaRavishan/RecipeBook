//
//  RecipeBookTests.swift
//  RecipeBookTests
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import XCTest
@testable import RecipeBook
import SDWebImageSwiftUI

class RecipeBookTests: XCTestCase {
    var recipeViewModel: FirebaseManager!
    
    override func setUp() {
        super.setUp()
        recipeViewModel = FirebaseManager()
    }
    
    override func tearDown() {
        recipeViewModel = nil
        super.tearDown()
    }
    
    func testFetchRecipes() {
        let expectation = XCTestExpectation(description: "Fetch recipes")
        
        recipeViewModel.fetchRecipes { recipes in
            XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddRecipe() {
        let expectation = XCTestExpectation(description: "Add recipe")
        
        let recipe = Recipe(
            id: "1",
            title: "Pancakes",
            ingredients: ["Flour", "Milk", "Eggs"],
            instructions: "1. Mix the ingredients\n2. Cook on a hot griddle",
            imageURL: nil
        )
        
        recipeViewModel.addRecipe(recipe)
        
        recipeViewModel.fetchRecipes { recipes in
            XCTAssertTrue(recipes.contains(recipe), "Recipes should contain the added recipe")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteRecipe() {
        let expectation = XCTestExpectation(description: "Delete recipe")
        
        let recipe = Recipe(
            id: "2",
            title: "Pizza",
            ingredients: ["Dough", "Tomato sauce", "Cheese", "Toppings"],
            instructions: "1. Roll out the dough\n2. Spread tomato sauce\n3. Add cheese and toppings\n4. Bake in the oven",
            imageURL: nil
        )
        
        recipeViewModel.addRecipe(recipe)
        
        recipeViewModel.deleteRecipe(recipe) { error in
            XCTAssertNil(error, "Error should be nil")
            
            recipeViewModel.fetchRecipes { recipes in
                XCTAssertFalse(recipes.contains(recipe), "Recipes should not contain the deleted recipe")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
