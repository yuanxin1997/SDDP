//
//  SafeDecodable.swift
//  FoodIn
//
//  Created by Yuanxin Li on 12/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            assertionFailure("ERROR: \(error)")
            // TODO: automatically send a report about a corrupted data
            self.value = nil
        }
    }
}
