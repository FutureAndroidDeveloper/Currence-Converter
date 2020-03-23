//
//  ConverterPresenter.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterPresentationLogic {
    func presentData(response: Converter.Model.Response.ResponseType)
}

class ConverterPresenter: ConverterPresentationLogic {
    weak var viewController: ConverterDisplayLogic?
    
    func presentData(response: Converter.Model.Response.ResponseType) {
        switch response {
        case .converterCurrencies(let first, let second):
            let viewModel = test(first, second)
            viewController?.displayData(viewModel: .showConverterViewModel(viewModel))
        }
    }
    
    private func test(_ a: Currency, _ b: Currency) -> ConverterViewModel {
        let aRate = Double(a.rate)
        let bRate = Double(b.rate)
        
        let x = round(bRate / aRate * pow(10, 4)) / pow(10, 4)
        let y = round(aRate / bRate * pow(10, 4)) / pow(10, 4)
        
        let aSymbol = getSymbol(forCurrencyCode: a.currency) ?? "Error"
        let bSymbol = getSymbol(forCurrencyCode: b.currency) ?? "Error"
        
        let first = Exchange(currency: a.currency,
                             rate: x,
                             regardingRate: "\(aSymbol)1=\(bSymbol)\(x)")
        let second = Exchange(currency: b.currency,
                              rate: y,
                              regardingRate: "\(bSymbol)1=\(aSymbol)\(y)")
        return ConverterViewModel(firstExchange: first, secondExchange: second)
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
}
