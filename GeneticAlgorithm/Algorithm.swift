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
            println("Warning! Population size must be even - adding 1.")
            self.populationSize = populationSize + 1
        } else {
            self.populationSize = populationSize
        }
        
        self.targetString = targetString
        self.population = []
    }
    
    public func execute() {
        println("Attempting to match '\(self.targetString)'")
        self .populate()
        self .run()
    }
    
    private func populate() {
        println("Initialising population")
        
        let numberOfGenes = count(self.targetString)
        
        for var i = 0; i < self.populationSize; i++ {
            var chromosome = Chromosome(numberOfGenes: numberOfGenes)
            self.population .append(chromosome)
        }
        
        println("Populating complete \(count(self.population))/\(populationSize)")
    }
    
    private func run() {
        println("Start evolving")
        var generationCounter = 1
        
        while (isFinished != true) {
            println("Generation: \(generationCounter)")
            
            // Run the algorithm
            self .selection()
            self .shufflePopulation()
            isFinished = self .analyze()
            
            generationCounter++
        }
        
        println("Target string has been matched")
    }
    
    private func selection() {
        for (var i = 0; i < self.population.count; i += 2) {
            
            // Breed adjacent chromosomes
            var parentOneChromosome = self.population[i]
            var parentTwoChromosome = self.population[i + 1]
            
            parentOneChromosome .compare(parentTwoChromosome, criteria: self.targetString, comparison: { (fittest, weakest) -> () in
                var weakestIndex = find(self.population, weakest)
                self.population[weakestIndex!] = parentOneChromosome .breed(parentTwoChromosome, target: self.targetString)
            })
        }
    }
    
    private func shufflePopulation() {
        self.population = self .shuffle(self.population)
    }
    
    private func analyze() -> Bool {
        
        var champion: Chromosome?
        
        for chromosome in self.population {
            if let fittestChromosome = champion {
                chromosome .compare(fittestChromosome, criteria: self.targetString, comparison: { (fittest, weakest) -> () in
                    champion = fittest
                })
            } else {
                champion = chromosome
            }
        }
        
        if let fittestChromosome = champion {
            println(fittestChromosome.geneSequence)
            return fittestChromosome.geneSequence == self.targetString
        }
        
        return false
    }
}

extension Algorithm {
    
    private func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = count(list)
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}
