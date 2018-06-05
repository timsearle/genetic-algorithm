//
//  Character.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 05/06/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

extension Character {
    
    func asciiValue() -> Int? {
        guard self.unicodeScalars.first?.isASCII == true,
            let value = self.unicodeScalars.first?.value else {
                return nil
        }
        
        return Int(value)
    }
    
    static func randomASCIIValue(range: Range<Int>? = nil) -> ASCIIValue {
        return Int.random(in: range ?? Range(uncheckedBounds: (lower: 32, upper: 126)))
    }
}
