//
//  Algorithm.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 13/04/2015.
//  Copyright (c) 2015 Tim Searle. All rights reserved.
//

import Foundation

public class Algorithm {

    private let populationSize = 1000
    private var targetString : String
    private var population : Array<Chromosome>
    private var isFinished = false
    
    init (target targetString: String) {
        self.targetString = targetString
        self.population = []
    }
    
    public func execute() {
        self .populate()
    }
    
    private func populate() {
        let numberOfGenes = count(self.targetString)
        
        for var i = 0; i < numberOfGenes; i++ {
            var chromosome = Chromosome(numberOfGenes: numberOfGenes)
            self.population .append(chromosome)
        }
    }
    
    private func run() {
        while (isFinished != true) {
            // Run the algorithm
            self .selection()
            self .shufflePopulation()
            isFinished = self .analyze()
        }
    }
    
    private func selection() {
        for (var i = 0; i < self.population.count; i++) {
            var parentOneChromosome = self.population[i]
            var parentTwoChromosome = self.population[i + 1]
            
            parentOneChromosome .compare(parentTwoChromosome, criteria: self.targetString, comparison: { (fittest, weakest) -> () in
                var weakestIndex = find(self.population, weakest)
                self.population[i] = parentOneChromosome .breed(parentTwoChromosome)
            })
        }
    }
    
    private func shufflePopulation() {
        var lastChromosome = self.population.last
        var firstChromosome = self.population.first
        
        if let chromosome = lastChromosome {
            self.population .insert(chromosome, atIndex: 0)
        }
        
        if let chromosome = firstChromosome {
            var randomIndex = Int(arc4random_uniform(UInt32(self.population.count - 1)))
            self.population .insert(chromosome, atIndex: randomIndex)
        }
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
            return fittestChromosome.geneSequence == self.targetString
        }
        
        return false
    }
    
}
