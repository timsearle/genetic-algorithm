//
//  Chromosome.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 18/04/2015.
//  Copyright (c) 2015 Tim Searle. All rights reserved.
//

import Foundation

public class Chromosome {
    
    public var geneSequence = ""
    
    private var fitnessCache: Array<Int>?
    
    private let lowerRange: Int = 32
    private let upperRange: Int = 126
    private let maxMutationDistance: UInt32 = 6
    
    init(numberOfGenes: Int) {
        self.geneSequence = self .createChromosome(numberOfGenes)
    }
    
    // MARK: Public
    
    public func compare(chromosome: Chromosome, criteria: String, comparison: (fittest: Chromosome, weakest: Chromosome) -> ()) {
        if self .fitness(criteria) > chromosome.fitness(criteria) {
            comparison(fittest: self, weakest: chromosome)
        } else {
            comparison(fittest: chromosome, weakest: self)
        }
    }
    
    public func breed(chromosome: Chromosome, target: String) -> Chromosome {

        let child = Chromosome(numberOfGenes: 0)
        
        for var i = 0; i < self.geneSequence.characters.count; i++ {
            
            let geneSequenceIndex = advance(self.geneSequence.startIndex, i)
            let mateIndex = advance(chromosome.geneSequence.startIndex, i)
            let targetIndex = advance(target.startIndex, i)
            
            let fittest = self .fittest(self.geneSequence[geneSequenceIndex], geneTwo: chromosome.geneSequence[mateIndex], target: target[targetIndex])
            
            child.geneSequence = child.geneSequence + String(fittest)
        }
        
        child .conditionalMutate()

        return child
    }

    // MARK: Private
    
    private func conditionalMutate() {
        
        if self .shouldMutate() {
            let mutationFactor = self .randomMutationFactor()
            
            var (gene, index) = self .randomGene()
            
            // Make sure valid
            if (gene.unicodeScalarCodePoint() + mutationFactor) < lowerRange || (gene.unicodeScalarCodePoint() + mutationFactor) > upperRange {
                return
            }
            
            gene = self .character(gene .unicodeScalarCodePoint() + mutationFactor)
            let range = Range(index...index)
            self.geneSequence = self.geneSequence .stringByReplacingCharactersInRange(range, withString: String(gene))
        }
    }
    
    private func fitness(criteria: String) -> Int {
        
        var totalFitness = 0
        
        for var i = 0; i < criteria.characters.count; i++ {
            
            var fitnessValue = 0
            
            if let cache = self.fitnessCache {
                if cache.count - 1 > i {
                    fitnessValue = cache[i]
                } else {
                    let geneSequenceIndex = advance(self.geneSequence.startIndex, i)
                    let criteriaIndex = advance(criteria.startIndex, i)
                    let fitnessValue = self.geneSequence[geneSequenceIndex].fitness(criteria[criteriaIndex])
                    self.fitnessCache?.insert(fitnessValue, atIndex: i)
                }
            } else {
                self.fitnessCache = []
                let geneSequenceIndex = advance(self.geneSequence.startIndex, i)
                let criteriaIndex = advance(criteria.startIndex, i)
                let fitnessValue = self.geneSequence[geneSequenceIndex].fitness(criteria[criteriaIndex])
                self.fitnessCache?.insert(fitnessValue, atIndex: i)
            }

            totalFitness = totalFitness + fitnessValue
        }
        
        return totalFitness
    }
    
    private func fittest(geneOne: Character, geneTwo: Character, target: Character) -> Character {
        return geneOne .fitness(target) > geneTwo .fitness(target) ? geneOne : geneTwo
    }
    
    private func createChromosome(length : Int) -> String {
        var chromosome = ""
        
        for var i = 0; i < length; i++ {
            let randomAsciiCharacter = Int .random(Range(lowerRange...upperRange))
        
            chromosome = chromosome + String(self .character(randomAsciiCharacter))
        }
        
        return chromosome
    }
    
    private func shouldMutate() -> Bool {
        return arc4random_uniform(10) >= 8
        // 20% chance
    }
    
    private func randomMutationFactor() -> Int {
        var mutationDelta = Int(arc4random_uniform(self.maxMutationDistance))
        
        if  (arc4random() % 2 == 0) {
            mutationDelta = mutationDelta * -1
        }
        
        return mutationDelta
    }
    
    private func randomGene() -> (Character, String.Index) {
        let randomIndexValue = Int(arc4random_uniform(UInt32(self.geneSequence.characters.count)))
        let randomIndex = advance(self.geneSequence.startIndex, randomIndexValue)
        return (self.geneSequence[randomIndex],randomIndex)
    }
    
    private func character(asciiCode: Int) -> Character {
        return Character(UnicodeScalar(asciiCode))
    }
}

// MARK: Extensions

extension Chromosome: Equatable {}

public func == (lhs: Chromosome, rhs: Chromosome) -> Bool {
    return lhs === rhs
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

extension Character {
    
    func unicodeScalarCodePoint() -> Int {
        let characterString = String(self)
        
        let scalars = characterString.unicodeScalars
        
        let point = scalars[scalars.startIndex]
        
        return Int(point.value)
    }
    
    func fitness(target: Character) -> Int {
        return abs(target.unicodeScalarCodePoint() - self.unicodeScalarCodePoint()) * -1
    }
}