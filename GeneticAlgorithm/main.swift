//
//  main.swift
//  GeneticAlgorithm
//
//  Created by Tim Searle on 12/04/2015.
//  Copyright (c) 2015 Tim Searle. All rights reserved.
//

import Foundation

let targetString = "This is a sample string. And below are various configurations and their output metrics"

let fitness: ([ASCIIValue], Int, ASCIIValue) -> Int = { (target, index, comparison) -> Int in
    return abs(comparison - target[index])
}

let configurationA = AlgorithmConfiguration(poolSize: 1, fitnessFunction: fitness)
let configurationB = AlgorithmConfiguration(poolSize: 10, fitnessFunction: fitness)
let configurationC = AlgorithmConfiguration(poolSize: 20, fitnessFunction: fitness)
let configurationD = AlgorithmConfiguration(poolSize: 100, fitnessFunction: fitness)
let configurationE = AlgorithmConfiguration(poolSize: 500, fitnessFunction: fitness)
let configurationF = AlgorithmConfiguration(poolSize: 1000, fitnessFunction: fitness)
let configurationG = AlgorithmConfiguration(poolSize: 10000, fitnessFunction: fitness)

let algorithmA = Algorithm(target: targetString, configuration: configurationA)
let algorithmB = Algorithm(target: targetString, configuration: configurationB)
let algorithmC = Algorithm(target: targetString, configuration: configurationC)
let algorithmD = Algorithm(target: targetString, configuration: configurationD)
let algorithmE = Algorithm(target: targetString, configuration: configurationE)
let algorithmF = Algorithm(target: targetString, configuration: configurationF)
let algorithmG = Algorithm(target: targetString, configuration: configurationG)

let algos = [("A",algorithmA),("B",algorithmB),("C",algorithmC),("D",algorithmD),("E",algorithmE),("F",algorithmF),("G",algorithmG)]

DispatchQueue.concurrentPerform(iterations: algos.count) { (index) in
    let (label,algo) = algos[index]
    
    let start = mach_absolute_time()
    let result = algo!.run()
    let end = mach_absolute_time()
    
    let elapsed = end - start
    
    var timebaseInfo = mach_timebase_info_data_t()
    mach_timebase_info(&timebaseInfo)
    
    let elapsedMilliseconds = elapsed * UInt64(timebaseInfo.numer) / UInt64(timebaseInfo.denom) / 1_000_000
    print("\(label): \(elapsedMilliseconds) milliseconds \(result)")
}
