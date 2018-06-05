//
//  Chromosome2.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 31/05/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

struct Chromosome2: Sequence, CustomStringConvertible {
    
    private let genes: [Character]
    
    private var cachedValue: Int?
    
    var description: String {
        return String(genes)
    }
    
    init(size: Int) {
        self.genes = (0..<size).map { _ in
            return Character.randomASCII()
        }
    }
    
    init(sequence: [Character]) {
        self.genes = sequence
    }
    
    func makeIterator() -> IndexingIterator<[Character]> {
        return self.genes.makeIterator()
    }

    func value(fitness: Fitness) -> Int {
        
        if let cachedValue = cachedValue {
            return cachedValue
        }
        
        var totalFitness = 0
        
        for (index,character) in self.genes.enumerated() {
            totalFitness += fitness(index,character)
        }
        
//        self.cachedValue = tota
        
        return totalFitness
    }
    
    func breed(with chromosome: Chromosome2, fitness: Fitness) -> Chromosome2 {
        var childSequence = genes
        
        for (index,(a,b)) in zip(self.genes,chromosome.genes).enumerated() {
            if fitness(index,a) > fitness(index,b) {
                childSequence[index] = shouldMutate() ? mutatedCharacter(from: b) : b
            } else {
                childSequence[index] = shouldMutate() ? mutatedCharacter(from: a) : a
            }
        }
        
        return Chromosome2(sequence: childSequence)
    }
    
    private func shouldMutate() -> Bool {
        return arc4random_uniform(100) > 70
    }
    
    private func mutatedCharacter(from character: Character) -> Character {
        return Character.randomASCII(range: Range(uncheckedBounds: (character.asciiValue() - 3, character.asciiValue())))
    }
}

extension Character {
    func asciiValue() -> Int {
        guard self.unicodeScalars.first?.isASCII == true else {
            fatalError("Only ASCII is supported")
        }
        
        return Int(self.unicodeScalars.first!.value)
    }
}

extension Character {
    static func randomASCII(range: Range<Int>? = nil) -> Character {
        let upper: UInt32 = UInt32(range?.upperBound ?? 126)
        let lower: UInt32 = UInt32(range?.lowerBound ?? 32)
        let value = arc4random_uniform(upper + 1 - lower) + lower
        
        return  Character.init(UnicodeScalar(value)!)
    }
}
