//
//  FavoriteInteractor.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteBusinessLogic {
    func makeRequest(request: Favorite.Model.Request.RequestType)
}

class FavoriteInteractor: FavoriteBusinessLogic {
    
    var presenter: FavoritePresentationLogic?
    var storage: StorageContext!
    
    init(storage: StorageContext = try! RealmStorageContext()) {
        self.storage = storage
    }
    
    func makeRequest(request: Favorite.Model.Request.RequestType) {
        switch request {
        case .loadCurrencies:
            fetchCurrencies()
            
        case .addFavorite(let model):
            update(model, isFavorite: true)
            presenter?.presentData(response: .update(viewModel: model, isSelected: true))
            
        case .removeFavorite(let model):
            update(model, isFavorite: false)
            let currency = Quote(currency: model.currency, rate: 0)
            FavoriteOrderService.shared.removeFromOrder(currency)
            presenter?.presentData(response: .update(viewModel: model, isSelected: false))
            
        case .filter(let title):
            presenter?.presentData(response: .filter(title: title))
        }
    }
    
    private func update(_ favorite: FavoriteViewModel, isFavorite: Bool) {
        let predicate = NSPredicate(format: "currency = %@", favorite.currency)
        storage.fetch(RealmCurrency.self, predicate: predicate, sorted: nil) { result in
            let selectedCurrency = result.first!
            try! storage.update {
                selectedCurrency.isFavorite = isFavorite
            }
        }
    }
    
    private func fetchCurrencies() {
        storage.fetch(RealmCurrency.self, predicate: nil, sorted: nil) { currencies in
            let currenciesInfo = CurrenciesInfoService.shared.fetch()
            self.presenter?.presentData(response: .currencies(currencies, currenciesInfo))
        }
    }
}

