//
//  Algorithm.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 13/04/2015.
//  Copyright (c) 2015 Tim Searle. All rights reserved.
//

import Foundation

public class Algorithm {

    private var populationSize: Int
    
    private var targetString : String
    private var population : Array<Chromosome>
    private var isFinished = false
    
    init (target targetString: String, populationSize: Int) {
        if populationSize % 2 != 0 {
            print("Warning! Population size must be even - adding 1.")
            self.populationSize = populationSize + 1
        } else {
            self.populationSize = populationSize
        }
        
        self.targetString = targetString
        self.population = []
    }
    
    public func execute() {
        print("Attempting to match '\(self.targetString)'")
        self .populate()
        self .run()
    }
    
    private func populate() {
        print("Initialising population")
        
        let numberOfGenes = self.targetString.count
        
        for _ in 0..<self.populationSize {
            let chromosome = Chromosome(numberOfGenes: numberOfGenes)
            self.population .append(chromosome)
        }
        
        print("Populating complete \(self.population.count)/\(populationSize)")
    }
    
    private func run() {
        print("Start evolving")
        var generationCounter = 1
        
        let start = CFAbsoluteTimeGetCurrent()
        
        while (isFinished != true) {
            
            print("Generation: \(generationCounter)")
            
            // Run the algorithm
            self .selection()
            self .shufflePopulation()
            isFinished = self .analyze()
            
            generationCounter += 1
        }
        
        let end = CFAbsoluteTimeGetCurrent()
        
        print("Target string has been matched")
        
        print("Completed in:  \(end - start) seconds")
    }
    
    private func selection() {
        for i in stride(from: 0, to: self.population.count, by: 2) {
            
            // Breed adjacent chromosomes
            let parentOneChromosome = self.population[i]
            let parentTwoChromosome = self.population[i + 1]
            
            // Replace weakest parent with child
            parentOneChromosome .compare(chromosome: parentTwoChromosome, criteria: self.targetString, comparison: { (fittest, weakest) -> () in
                let weakestIndex = self.population.index(of:weakest)
                self.population[weakestIndex!] = parentOneChromosome .breed(chromosome: parentTwoChromosome, target: self.targetString)
            })
        }
    }
    
    private func shufflePopulation() {
        self.population.shuffle()
    }
    
    private func analyze() -> Bool {
        
        var champion: Chromosome?
        
        for chromosome in self.population {
            if let fittestChromosome = champion {
                chromosome .compare(chromosome: fittestChromosome, criteria: self.targetString, comparison: { (fittest, weakest) -> () in
                    champion = fittest
                })
            } else {
                champion = chromosome
            }
        }
        
        if let fittestChromosome = champion {
            print(fittestChromosome.geneSequence)
            return fittestChromosome.geneSequence == self.targetString
        }
        
        return false
    }
}

extension Array {
    
    mutating func shuffle() {
        
        for i in 0..<self.count {
            let randomSwapIndex = Int(arc4random_uniform(UInt32(self.count - 1 - i + 1))) + i
            self.swapAt(i, randomSwapIndex)
        }
        
    }
}
