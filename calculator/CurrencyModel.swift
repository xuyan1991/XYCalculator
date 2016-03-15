//
//  CurrencyModel.swift
//  calculator
//
//  Created by 徐岩 on 16/3/14.
//  Copyright © 2016年 xuyan. All rights reserved.
//
import Foundation
import UIKit
class CurrencyModel {
    
    var countryName: String
    var countryImage: UIImage

    //private var country:[JSON]
    init(name: String, image: UIImage) {
        self.countryImage = image
        self.countryName = name
    }

}