//
//  Algorithm.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 31/05/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation
import os

typealias ASCIIValue = Int

struct Mutation {
    let width: Int
    let rate: Double
    
    static var `default`: Mutation {
        return Mutation(width: 3, rate: 0.3)
    }
    
    func shouldMutate() -> Bool {
        return true
    }
}

struct AlgorithmConfiguration {
    
    enum StringType {
        case ascii
    }
    
    let poolSize: Int
    let mutation: Mutation = .default
    let type: StringType = .ascii
    let fitnessFunction: FitnessCalculator
}

struct AlgorithmResult {
    let poolSize: Int
    let generationCount: Int
    let inputStringSize: Int
}

struct Algorithm {
    
    private let configuration: AlgorithmConfiguration
    private let ascii: [Int]
    private let target: String
    private let fitness: Fitness
    
    init?(target: String, configuration: AlgorithmConfiguration) {
        self.configuration = configuration
        self.target = target
        
        guard let ascii = target.ascii() else {
            return nil
        }
        
        self.ascii = ascii
        self.fitness = Fitness(goal: ascii, function: configuration.fitnessFunction)
    }
    
    func run() -> AlgorithmResult {
        
        var pool = seedPool(size: configuration.poolSize)
        var counter = 0
        
        while !isSuccessful(pool: pool) {
            counter += 1
            pool = breed(pool: pool).shuffled()
        }
        
        return AlgorithmResult(poolSize: configuration.poolSize, generationCount: counter, inputStringSize: target.count)
    }
    
    private func seedPool(size: Int) -> [Chromosome] {
        return (0..<size).map { _ in
            return Chromosome(size: target.count, fitness: fitness)
        }
    }
    
    private func isSuccessful(pool: [Chromosome]) -> Bool {
        
        for chromo in pool {
            if chromo.value == 0 {
                return true
            }
        }
        
        return false
    }
    
    private func breed(pool: [Chromosome]) -> [Chromosome] {
        
        guard !pool.isEmpty else {
            return pool
        }
        
        var outputPool = Set<Chromosome>()
        
        for chromo in pool {
            guard let random = pool.randomElement() else {
                continue
            }
            
            let child = Chromosome(parentA: chromo, parentB: random, fitness: fitness)
            outputPool.insert(child)
            
            if child.value == 0 {
              //  break
            }
        }
        
        return Array(outputPool)
    }
}
