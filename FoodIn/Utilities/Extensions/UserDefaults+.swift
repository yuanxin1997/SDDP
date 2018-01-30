//
//  UserDefaults+.swift
//  FoodIn
//
//  Created by Yuanxin Li on 29/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
