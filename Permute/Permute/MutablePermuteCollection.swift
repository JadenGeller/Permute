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

public struct MutablePermuteCollection<Collection: MutableCollectionType> {
    internal var backing: Collection
    public var permutation: AnyPermuatation<Collection.Index>
    
    public init<P: PermutationType where P.Index == Collection.Index>(_ collection: Collection, withPermutation permutation: P) {
        self.backing = collection
        self.permutation = AnyPermuatation(permutation)
    }
}

extension MutablePermuteCollection: MutableCollectionType {
    public var startIndex: Collection.Index {
        return backing.startIndex
    }
    
    public var endIndex: Collection.Index {
        return backing.endIndex
    }
    
    public subscript(index: Collection.Index) -> Collection.Generator.Element {
        get {
            return backing[permutation[index]]
        } set {
            backing[permutation[index]] = newValue
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

