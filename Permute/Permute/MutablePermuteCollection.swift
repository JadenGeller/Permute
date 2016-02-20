//
//  MutablePermuteCollection.swift
//  Permute
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension MutableCollectionType {
    public func permute<P: PermutationType where P.Index == Index>(permutation: P) -> MutablePermuteCollection<Self> {
        return MutablePermuteCollection(self, withPermutation: permutation)
    }
}

public struct MutablePermuteCollection<Base: MutableCollectionType> {
    public var base: Base
    public var permutation: AnyPermutation<Base.Index>
    
    public init<P: PermutationType where P.Index == Base.Index>(_ collection: Base, withPermutation permutation: P) {
        self.base = collection
        self.permutation = AnyPermutation(permutation)
    }
}

extension MutablePermuteCollection: PermuteCollectionType, MutableCollectionType {
    public var startIndex: Base.Index {
        return base.startIndex
    }
    
    public var endIndex: Base.Index {
        return base.endIndex
    }
    
    public subscript(index: Base.Index) -> Base.Generator.Element {
        get {
            return base[permutation[index]]
        } set {
            base[permutation[index]] = newValue
        }
    }
}

extension MutablePermuteCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<C: MutableCollectionType where C.Generator.Element: Equatable>(lhs: MutablePermuteCollection<C>, rhs: MutablePermuteCollection<C>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

