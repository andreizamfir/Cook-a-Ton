//
//  SearchRecipeViewController.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import UIKit
import Combine

class RecipeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var btnGetRecipe: UIButton!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lblRecipeName: UILabel!
    
    
    // MARK: - Properties
    
    lazy var recipeViewModel: RecipeViewModel = { RecipeViewModel() }()
    private var cancellables: Set<AnyCancellable> = []
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.recipeViewModel.$recipe.sink(receiveValue: { recipe in
            self.updateViewData(recipe)
        })
        .store(in: &cancellables)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func getRandomRecipe(_ sender: UIButton) {
        self.recipeViewModel.fetchRandomRecipe()
    }
    
    
    // MARK: - View updates
    
    private func updateViewData(_ recipe: [Recipe] ) {
        if recipe.isEmpty {
            return
        }
        
        self.lblRecipeName.text = recipe[0].recipes[0].title
        setImageFromStringURL(stringUrl: recipe[0].recipes[0].image)
    }
    
    private func setImageFromStringURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                // Error handling...
                guard let imageData = data else { return }

                DispatchQueue.main.async {
                    self.imgRecipe.image = UIImage(data: imageData)
                }
            }.resume()
        }
    }
    
}
