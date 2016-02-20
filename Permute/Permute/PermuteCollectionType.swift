//
//  PermuteCollectionType.swift
//  Permute
//
//  Created by Jaden Geller on 2/20/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol PermuteCollectionType: CollectionType {
    typealias Base: CollectionType
    var base: Base { get set }
    var permutation: AnyPermutation<Base.Index> { get set }
}