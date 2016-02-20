//
//  RangeReplaceableMutableLazyShuffleCollection.swift
//  Erratic
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

extension RangeReplaceableCollectionType where Index: BidirectionalIndexType, Index: Comparable, Index.Distance == Int {
    public func permute<P: PermutationType where P.Index == Index>(permutation: P) -> RangeReplaceablePermuteCollection<Self> {
        return RangeReplaceablePermuteCollection(self, withPermutation: permutation)
    }
}

public struct RangeReplaceablePermuteCollection<Base: RangeReplaceableCollectionType where Base.Index: BidirectionalIndexType, Base.Index: Comparable, Base.Index.Distance == Int> {
    public var base: Base
    public var permutation: AnyPermuatation<Base.Index>
    
    public init<P: PermutationType where P.Index == Base.Index>(_ collection: Base, withPermutation permutation: P) {
        self.base = collection
        self.permutation = AnyPermuatation(permutation)
    }

}

extension RangeReplaceablePermuteCollection: MutableCollectionType {
    public var startIndex: Base.Index {
        return base.startIndex
    }
    
    public var endIndex: Base.Index {
        return base.endIndex
    }
    
    public subscript(index: Base.Index) -> Base.Generator.Element {
        get {
            print("\(index) -> \(permutation[index])")
            return base[permutation[index]]
        }
        set {
            let index = permutation[index]
            base.replaceRange(index...index, with: [newValue])
        }
    }
}

extension RangeReplaceablePermuteCollection: RangeReplaceableCollectionType {
    public init() {
        self.init(Base(), withPermutation: IdentityPermutation())
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Base.Generator.Element>(subRange: Range<Base.Index>, with newElements: C) {
        
        // Update all elements in the overlapping ranges, adding elements and recording which to delete
        var newElementIndexGenerator = newElements.indices.generate()
        var subRangeIndexGenerator = subRange.indices.generate()
        var delta = 0
        var indicesToRemove: [Base.Index] = []
        loop: while true {
            switch (newElementIndexGenerator.next(), subRangeIndexGenerator.next()) {
            case let (newElementIndex?, subRangeIndex?):
                self[subRangeIndex] = newElements[newElementIndex]
            case let (newElementIndex?, nil):
                base.append(newElements[newElementIndex])
                delta += 1
            case let (nil, subRangeIndex?):
                indicesToRemove.append(permutation[subRangeIndex])
                delta -= 1
            case (nil, nil): break loop
            }
        }
        // Delete in reverse order so the indexes don't change.
        indicesToRemove.sort().reverse().forEach { base.removeAtIndex($0) }
        
        if delta > 0 {
            // Account for inserted elements
            let endIndex = base.endIndex
            let addedElementsRange = subRange.endIndex..<subRange.endIndex.advancedBy(delta)
            let oldPermutation = permutation
            permutation = AnyPermuatation { index in
                if index < addedElementsRange.startIndex {
                    // Elements prior to insertion have not moved.
                    return oldPermutation[index]
                } else if addedElementsRange.contains(index) {
                    // Inserted elements are added to the end of the collection.
                    let offset = addedElementsRange.startIndex.distanceTo(index)
                    return endIndex.advancedBy(offset - delta)
                } else if index >= addedElementsRange.endIndex {
                    // Elements after the inserted elements must be treated as if
                    // their index increased by delta.
                    return oldPermutation[index.advancedBy(-delta)]
                } else {
                    fatalError() // Should never occur
                }
            }
        } else if delta < 0 {
            // Account for removed elements
            let deletedElementsRange = subRange.endIndex.advancedBy(delta)..<subRange.endIndex
            let oldPermutation = permutation
            permutation = AnyPermuatation { index in
                // Skip deleted elements, effectively decreasing everything's index
                let elementIndex = index >= deletedElementsRange.startIndex ? index.advancedBy(deletedElementsRange.count) : index
    
                // Get actual index in array by accounting for shifts due to deletion
                let backingIndex = oldPermutation[elementIndex]
                var offset = 0
                // For any deleted index we're actually past, decrement our actual index
                for deletedElementIndex in deletedElementsRange {
                    let deletedElementBackingIndex = oldPermutation[deletedElementIndex]
                    if backingIndex >= deletedElementBackingIndex { offset += 1 }
                }
                return backingIndex.advancedBy(-offset)
            }
        }
    }
}

extension RangeReplaceablePermuteCollection: CustomStringConvertible {
    public var description: String {
        return String(Array(self))
    }
}

public func ==<C: RangeReplaceableCollectionType, P: PermutationType where P.Index == C.Index, C.Generator.Element: Equatable>(lhs: RangeReplaceablePermuteCollection<C>, rhs: RangeReplaceablePermuteCollection<C>) -> Bool {
    return lhs.count == rhs.count && zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}
