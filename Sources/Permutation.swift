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
    @warn_unused_result public func apply<S: SequenceType where S.Generator.Element == Index>(indices: S) -> [Index] {
        return indices.map { self[$0] }
    }
}

public struct AnyPermutation<Index>: PermutationType {
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
    @warn_unused_result public func apply<S : SequenceType where S.Generator.Element == Index>(indices: S) -> [Index] {
        return Array(indices)
    }
}

public struct SwapPermutation<Index: Hashable>: PermutationType {
    private var backing: [Index : Index] = [:]
    
    public init(swaps: (Index, Index)...) {
        self.init(swaps: swaps)
    }
    
    public init<S: SequenceType where S.Generator.Element == (Index, Index)>(swaps: S) {
        swaps.forEach { (lhs, rhs) in swapInPlace(lhs, rhs) }
    }
    
    public mutating func swapInPlace(lhs: Index, _ rhs: Index) {
        let newRhs = backing[lhs] ?? lhs
        let newLhs = backing[rhs] ?? rhs
        backing[rhs] = newRhs == rhs ? nil : newRhs
        backing[lhs] = newLhs == lhs ? nil : newLhs
    }
    
    @warn_unused_result public func swap(lhs: Index, _ rhs: Index) -> SwapPermutation {
        var copy = self
        copy.swapInPlace(lhs, rhs)
        return copy
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
