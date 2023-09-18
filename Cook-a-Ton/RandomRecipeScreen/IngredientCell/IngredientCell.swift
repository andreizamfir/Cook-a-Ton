//
//  IngredientCell.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 12.09.2023.
//

import UIKit

class IngredientCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var lblIngredientName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    
    // MARK: - Properties
    
    var ingredient: Ingredient? {
        didSet {
            setupData()
        }
    }
    
    
    // MARK: - Initialization
    
    private func setupData() {
        guard let ingredient = self.ingredient else {
            return
        }
        
        lblIngredientName.text = ingredient.name
        lblAmount.text = "\(ingredient.amount) \(ingredient.unit)"
    }
    
}
