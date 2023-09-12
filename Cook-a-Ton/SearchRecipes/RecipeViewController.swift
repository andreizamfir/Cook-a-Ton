//
//  SearchRecipeViewController.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import UIKit
import Combine

class IngredientsTableViewDiffableDataSource: UITableViewDiffableDataSource<String, Ingredient> {}

class RecipeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var btnGetRecipe: UIButton!
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblTimeToMake: UILabel!
    @IBOutlet weak var lblServings: UILabel!
    @IBOutlet weak var tvIngredients: UITableView!
    
    
    // MARK: - Properties
    
    lazy var recipeViewModel: RecipeViewModel = { RecipeViewModel() }()
    private var cancellables: Set<AnyCancellable> = []
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        setupObservers()
        bindViewModel()
        self.recipeViewModel.fetchRandomRecipe()
    }
    
    private func bindViewModel() {
        self.recipeViewModel.$recipe.sink(receiveValue: { recipe in
            self.updateViewData(recipe)
        })
        .store(in: &cancellables)
    }
    
    
    // MARK: - Initialization
    
    private func initializeTableView() {
        tvIngredients.register(UINib(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: kIngredientCellIdentifier)
    }
    
    private func setupObservers() {
        recipeViewModel.diffableDataSource = IngredientsTableViewDiffableDataSource(tableView: tvIngredients) { (tableView, indexPath, model) -> UITableViewCell? in
                    
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kIngredientCellIdentifier, for: indexPath) as? IngredientCell
            else {
                return UITableViewCell()
            }
                    
            cell.ingredient = model
            return cell
        }
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
        
        if let recipe = recipe.last?.recipes[0] {
            self.lblRecipeName.text = recipe.title
            self.lblTimeToMake.text = "Time to make: \(recipe.readyInMinutes) mins"
            self.lblServings.text = "Servings: \(recipe.servings)"
            self.setImageFromStringURL(stringUrl: recipe.image)
        }
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
