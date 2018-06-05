//
//  Chromosome.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 31/05/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

struct Chromosome: Hashable {
    
    private let genes: [ASCIIValue]
    let value: Int
    
    var contents: String {
        return String(genes.map {
            Character(Unicode.Scalar($0)!)
        })
    }
    
    init(size: Int, fitness: Fitness) {
        let sequence = (0..<size).map { _ in
            return Character.randomASCIIValue()
        }
        
        self.init(sequence: sequence, fitness: fitness)
    }
    
    init(sequence: [ASCIIValue], fitness: Fitness) {
        
        var totalFitness = 0
        
        for (index,character) in sequence.enumerated() {
            totalFitness += fitness.calculate(index: index, value: character)
        }
        
        self.value = totalFitness
        self.genes = sequence
    }
    
    init(parentA: Chromosome, parentB: Chromosome, fitness: Fitness, mutation: Mutation = .default) {
        
        func updateSequence(_ fitnessValue: Int, _ sequence: inout [Int], _ index: Int, _ currentChar: ASCIIValue, _ mutation: Mutation, _ fitness: Fitness) {
            if fitnessValue == 0 {
                sequence[index] = currentChar
            } else {
                let proposedChar = mutation.shouldMutate() ? Character.randomASCIIValue(range: ((currentChar - mutation.width)..<(currentChar + mutation.width))) : currentChar
                if fitness.calculate(index: index, value: proposedChar) < fitnessValue {
                    sequence[index] = proposedChar
                } else {
                    sequence[index] = currentChar
                }
            }
        }
        
        var childSequence = parentA.genes
        
        for (index,(a,b)) in zip(parentA.genes,parentB.genes).enumerated() {
            
            let aFitness = fitness.calculate(index: index, value: a)
            let bFitness = fitness.calculate(index: index, value: b)
            
            if aFitness > bFitness {
                updateSequence(bFitness, &childSequence, index, b, mutation, fitness)
            } else {
                updateSequence(aFitness, &childSequence, index, a, mutation, fitness)
            }
        }
        
        self.init(sequence: childSequence, fitness: fitness)
    }
}
