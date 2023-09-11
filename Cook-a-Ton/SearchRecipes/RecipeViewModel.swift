//
//  RecipeViewModel.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var recipe : [Recipe] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Get data
    
    func fetchRandomRecipe() {
        let getRandomRecipesURL = kBaseUrl + kRandomRecipeUrl + kAddApiKey + kApikey
        
        APICaller.shared.getData(endpoint: getRandomRecipesURL, type: Recipe.self)
            .sink { completion in // (3) -> Subscriber
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] appResponse in
                self?.recipe.append(appResponse)
            } .store(in: &cancellables) // (4)
    }
    
}
