//
//  ConverterRouter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterRoutingLogic {
    func showChoiceViewController()
    func showFavoriteViewController()
}

class ConverterRouter: ChoiceDataPassing {
    weak var viewController: ConverterViewController?
    var dataStore: ChoiceDataStore?
    
    // MARK: Routing
    func showChoiceViewController() {
        guard let viewController = viewController else {
            fatalError("Fail route to second")
        }
        let choiceVc = ChoiceViewController(nib: R.nib.choiceViewController)
        present(source: viewController, destination: choiceVc)
    }
    
    func showFavoriteViewController() {
        guard let viewController = viewController,
            let navigationController = viewController.navigationController else {
                fatalError("Fail route to second")
        }
        let favoriteViewController = FavoriteViewController(nib: R.nib.favoriteViewController)
        navigationController.pushViewController(favoriteViewController, animated: true)
    }
}

// MARK: - Navigation
extension ConverterRouter: ConverterRoutingLogic {
    private func present(source: UIViewController, destination: UIViewController) {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source as? ConverterViewController
        source.present(destination, animated: true, completion: nil)
    }
}

