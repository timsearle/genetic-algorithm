//
//  Fitness.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 05/06/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

typealias FitnessCalculator = (_ target: [ASCIIValue], _ index: Int, _ comparator: ASCIIValue) -> Int

struct Fitness {
    let goal: [ASCIIValue]
    let function: FitnessCalculator
    
    func calculate(index: Int, value: ASCIIValue) -> Int {
        return function(goal, index, value)
    }
}
