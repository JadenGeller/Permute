//
//  PermuteCollectionType.swift
//  Permute
//
//  Created by Jaden Geller on 2/20/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol PermuteCollectionType: CollectionType {
    typealias Base: CollectionType
    typealias Permutation: PermutationType
    var base: Base { get set }
    var permutation: Permutation { get set }
}