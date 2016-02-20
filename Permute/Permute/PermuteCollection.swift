//
//  PermuteCollection.swift
//  Permute
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension CollectionType {
    public func permute<P: PermutationType where P.Index == Index>(permutation: P) -> PermuteCollection<Self> {
        return PermuteCollection(self, withPermutation: permutation)
    }
}

public struct PermuteCollection<Collection: CollectionType> {
    internal var backing: Collection
    public var permutation: AnyPermuatation<Collection.Index>

    public init<P: PermutationType where P.Index == Collection.Index>(_ collection: Collection, withPermutation permutation: P) {
        self.backing = collection
        self.permutation = AnyPermuatation(permutation)
    }
}

extension PermuteCollection: CollectionType {
    public var startIndex: Collection.Index {
        return backing.startIndex
    }
    
    public var endIndex: Collection.Index {
        return backing.endIndex
    }
    
    public subscript(index: Collection.Index) -> Collection.Generator.Element {
    	get {
    		return backing[permutation[index]]
    	}
    }
}

extension PermuteCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<C: CollectionType where C.Generator.Element: Equatable>(lhs: PermuteCollection<C>, rhs: PermuteCollection<C>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

