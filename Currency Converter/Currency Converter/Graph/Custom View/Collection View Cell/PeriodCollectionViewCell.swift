//
//  CollectionViewCell.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class PeriodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var periodLabel: UILabel!
    
    private let gradientName = "gradient"
    
    override var isSelected: Bool {
        didSet {
            if oldValue == self.isSelected { return }
            self.isSelected ? select() : deselect()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = bounds.width / 10
    }
    
    private func select() {
        let gradientLayer = CAGradientLayer()
        let startColor = #colorLiteral(red: 0.4196078431, green: 0.5176470588, blue: 0.9764705882, alpha: 1)
        let endColor = #colorLiteral(red: 0.3647058824, green: 0.5647058824, blue: 0.9921568627, alpha: 1)
        gradientLayer.name = gradientName
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        periodLabel.textColor = .white
    }
    
    private func deselect() {
        periodLabel.textColor = .black
        let gradientLayer = layer.sublayers?
            .filter { $0.name == gradientName }
            .first
        gradientLayer?.removeFromSuperlayer()
    }
}
