//
//  Chromosome.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 18/04/2015.
//  Copyright (c) 2015 Tim Searle. All rights reserved.
//

import Foundation

public class Chromosome: Equatable {
    
    public var geneSequence = ""
    
    private var lowerRange : UInt32 = 32
    private var upperRange : UInt32 = 126
    
    init(numberOfGenes: Int) {
        self.geneSequence = self .createChromosome(numberOfGenes)
    }
    
    public func compare(chromosome: Chromosome, criteria: String, comparison: (fittest: Chromosome, weakest: Chromosome) -> ()) {
        if self.fitness(criteria) > chromosome.fitness(criteria) {
            comparison(fittest: self, weakest: chromosome)
        } else {
            comparison(fittest: chromosome, weakest: self)
        }
    }
    
    public func breed(chromosome: Chromosome) -> Chromosome {
        // TODO: Crossover algorithm for both chromosomes
        return self
    }
    
    private func fitness(criteria: String) -> Int {
        
        var fitness = 0
        
        for var i = 0; i < count(criteria); i++ {
            
            let geneSequenceIndex = advance(self.geneSequence.startIndex, i)
            let criteriaIndex = advance(criteria.startIndex, i)
            
            fitness = fitness + self .fitness(self.geneSequence[geneSequenceIndex], target: criteria[criteriaIndex])
        }
        
        return fitness
    }
    
    private func fitness(gene: Character, target: Character) -> Int {
        
        return abs(target.unicodeScalarCodePoint() - gene.unicodeScalarCodePoint()) * -1
    }
    
    private func createChromosome(length : Int) -> String {
        var chromosome = ""
        
        for var i = 0; i < length; i++ {
            let randomAsciiCharacter = Int(arc4random_uniform(upperRange) + lowerRange)
            chromosome .append(self .string(randomAsciiCharacter))
        }
        
        return chromosome
    }
    
    private func string(asciiCode: Int) -> Character {
        return Character(UnicodeScalar(asciiCode))
    }
}

extension Chromosome: Equatable {}

public func == (lhs: Chromosome, rhs: Chromosome) -> Bool {
    return lhs === rhs
}

extension Character {
    
    func unicodeScalarCodePoint() -> Int {
        let characterString = String(self)
        
        let scalars = characterString.unicodeScalars
        
        let point = scalars[scalars.startIndex]
        
        return Int(point.value)
    }
}