//
//  Algorithm2.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 31/05/2018.
//  Copyright © 2018 Tim Searle. All rights reserved.
//

import Foundation

typealias Fitness = (Int,Character) -> Int

extension String {
    subscript (index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}

struct Algorithm2 {
    
    private var pool: [Chromosome2]
    private let target: String
    
    init(target: String, poolSize: Int) {
        self.pool = (0..<poolSize).map { _ in
            return Chromosome2(size: target.count)
        }
        self.target = target
    }
    
    mutating func run() {
        while !isPoolSuccessful() {
            pool = breed(pool: pool)
            pool.shuffle()
        }
        
        print("Done!")
    }
    
    private func fitness(index: Int, character: Character) -> Int {
        return abs(character.asciiValue()
            - target[index].asciiValue())
    }
    
    private func isPoolSuccessful() -> Bool {
        
        var fittest = pool.first?.value(fitness: fitness) ?? 0
        var fittestChromo = pool.first!
        
        pool
            .forEach {
                let value = $0.value(fitness: fitness)
                if value < fittest {
                    fittest = value
                    fittestChromo = $0
                }
            }
        
        print(fittest)
        print(fittestChromo)
        
        return fittest == 0
    }
    
    private func breed(pool: [Chromosome2]) -> [Chromosome2] {
        
        guard !pool.isEmpty, var previous = pool.first else {
            return pool
        }
        
        var outputPool = [Chromosome2]()
        
        for chromo in pool.dropFirst() {
            let child = previous.breed(with: chromo, fitness: fitness(index:character:))
            outputPool.append(child)
            outputPool.append(chromo.value(fitness: fitness) < previous.value(fitness: fitness) ? chromo : previous)
            previous = chromo
        }
        
        return outputPool
    }
}
