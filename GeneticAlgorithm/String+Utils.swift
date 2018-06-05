//
//  String+Utils.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 05/06/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

extension String {
    subscript (index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func ascii() -> [ASCIIValue]? {
        
        var ascii = [ASCIIValue]()
        
        for character in self {
            if let asciiValue = character.asciiValue() {
                ascii.append(asciiValue)
            } else {
                return nil
            }
        }
        
        return ascii
    }
}
