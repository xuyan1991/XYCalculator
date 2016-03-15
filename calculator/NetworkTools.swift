//
//  NetworkTools.swift
//  calculator
//
//  Created by 徐岩 on 16/3/15.
//  Copyright © 2016年 xuyan. All rights reserved.
//

import Foundation
import Alamofire
class NetWorkTools {
    let request = Alamofire.request(.GET, "http://apis.baidu.com/apistore/currencyservice/type",headers:["apikey": "a7c0f1c570be9e0f9f09ef88213ce7b1"])
    .responseJSON { _, _, result in
    print(result)
    debugPrint(result)
    }
    
    
}