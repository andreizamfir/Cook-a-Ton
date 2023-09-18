//
//  RecipeViewModel.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import Foundation
import Combine
import UIKit

class RecipeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var recipe : [Recipe] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Source
    // https://medium.com/dataseries/mixing-diffabledatasource-with-uikit-and-combine-part-1-ios-movies-catalogue-65cf90e37305
    
    var diffableDataSource: IngredientsTableViewDiffableDataSource!
    var snapshot = NSDiffableDataSourceSnapshot<String, Ingredient>()
    
    
    // MARK: - Get data
    
    func fetchRandomRecipe() {
        let getRandomRecipesURL = kBaseUrl + kRandomRecipeUrl + kAddApiKey + kApikey
        
        APICaller.shared.getData(endpoint: getRandomRecipesURL, type: Recipe.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] appResponse in
                // Publish value to recipe property
                self?.recipe.append(appResponse)
                
                guard self?.diffableDataSource != nil else { return }
                
                // Create a snapshot to populate with the state of data
                self?.snapshot.deleteAllItems()
                self?.snapshot.appendSections([""])
                
                guard let firstRecipeData = appResponse.recipeData.first else { return }
                
                self?.snapshot.appendItems(firstRecipeData.extendedIngredients, toSection: "")
                
                // Apply the snapshot to reflect the changes in UI
                if let snapshot = self?.snapshot {
                    self?.diffableDataSource.apply(snapshot)
                }
            } .store(in: &cancellables)
    }
    
}
