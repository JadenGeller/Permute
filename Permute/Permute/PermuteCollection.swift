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

public struct PermuteCollection<Base: CollectionType> {
    public var base: Base
    public var permutation: AnyPermuatation<Base.Index>

    public init<P: PermutationType where P.Index == Base.Index>(_ collection: Base, withPermutation permutation: P) {
        self.base = collection
        self.permutation = AnyPermuatation(permutation)
    }
}

extension PermuteCollection: CollectionType {
    public var startIndex: Base.Index {
        return base.startIndex
    }
    
    public var endIndex: Base.Index {
        return base.endIndex
    }
    
    public subscript(index: Base.Index) -> Base.Generator.Element {
    	get {
    		return base[permutation[index]]
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

