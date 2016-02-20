# Permute

Permute allows you create permutated views of a collection without duplicating memory or rearranging the original collection. Even cooler, Permute provides a `RangeReplaceableCollectionType` collection that enables appending too, mutating, and deleting from a permuted collection in a way that actually mutates the original as well (still without changing the order)!

```swift
var bar = [1, 2, 3, 4, 5].permute(SequencedPermuation(indices: [3, 1, 0, 2, 4]))
print(bar) // -> [4, 2, 1, 3, 5]
bar.insert(100, atIndex: 3)
bar[0] = 200
print(bar) // -> [200, 2, 1, 100, 3, 5]
```

Permute defines a protocol `PermutationType` that describes type which can be used to permute a collection. The most basic is `SequencedPermutation` which will order the array as specified by the list of indicies. Note that this list of indices must be the same length as the array otherwise an our of bounds error might occur. Another useful permutation type, `SwapPermutation`, allows you to specify the ordering of the items in terms of index swaps.

```swift
var foo = [1, 2, 3, 4, 5].permute(SwapPermutation(swaps: (0, 1), (2, 3)))
print(foo) // -> [2, 1, 4, 3, 5]
foo.replaceRange(1...3, with: [10])
print(foo) // -> [2, 10, 5]
```

If you want to access the base collection (the collection the permutation is applied to), use the `base` property. Also, you can assign new permutations to a collection by upating the `permutation` property. (Note that this is of type `AnyPermutation`
so that the backing permutation can be updated to a custom transformation when elements are added or removed from the array.)

```swift
var permutation = SwapPermutation(swaps: (0, 4))
var foo = [1, 2, 3, 4, 5].permute(permutation)
print(foo)      // -> [5, 2, 3, 4, 1]
print(foo.base) // -> [1, 2, 3, 4, 5]
foo.permutation = AnyPermutation(permutation.swap(1, 3))
print(foo)      // -> [5, 4, 3, 2, 1]
print(foo.base) // -> [1, 2, 3, 4, 5]
foo.insert(6, atIndex: 0)
print(foo)      // -> [6, 5, 4, 3, 2, 1]
print(foo.base) // -> [1, 2, 3, 4, 5, 6]
```
