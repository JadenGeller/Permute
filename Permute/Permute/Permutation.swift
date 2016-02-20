//
//  Permutation.swift
//  Permute
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol PermutationType {
    typealias Index
    subscript(index: Index) -> Index { get }
}

extension PermutationType {
    public func apply<S: SequenceType where S.Generator.Element == Index>(indices: S) -> [Index] {
        return indices.map { self[$0] }
    }
}

public struct AnyPermuatation<Index>: PermutationType {
    private let transform: Index -> Index

    public init<P: PermutationType where P.Index == Index>(_ permutation: P) {
        self.transform = { index in permutation[index] }
    }
    
    public init(transform: Index -> Index) {
        self.transform = transform
    }
    
    public subscript(index: Index) -> Index {
        return transform(index)
    }
}

public struct IdentityPermutation<Index>: PermutationType {
    public init() { }
    
    public subscript(index: Index) -> Index {
        return index
    }
    
    // optimization
    public func apply<S : SequenceType where S.Generator.Element == Index>(indices: S) -> [Index] {
        return Array(indices)
    }
}

public struct SwapPermutation<Index: Hashable>: PermutationType {
    private var backing: [Index : Index] = [:]
    
    public init<S: SequenceType where S.Generator.Element == (Index, Index)>(swaps: S) {
        swaps.forEach { (lhs, rhs) in swap(lhs, rhs) }
    }
    
    public mutating func swap(lhs: Index, _ rhs: Index) {
        let newRhs = backing[lhs] ?? lhs
        let newLhs = backing[rhs] ?? rhs
        backing[rhs] = newRhs == rhs ? nil : newRhs
        backing[lhs] = newLhs == lhs ? nil : newLhs
    }
    
    public subscript(index: Index) -> Index {
        return backing[index] ?? index
    }
}

public struct SequencedPermuation: PermutationType {
    private let backing: [Int]
    
    public init<S: SequenceType where S.Generator.Element == Int>(indices: S) {
        self.backing = Array(indices)
    }
    public subscript(index: Int) -> Int {
        return backing[index]
    }
}
