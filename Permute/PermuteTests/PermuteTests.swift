//
//  PermuteTests.swift
//  PermuteTests
//
//  Created by Jaden Geller on 2/19/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Permute

class PermuteTests: XCTestCase {
    func testRangeReplaceableSetIndex() {
        var collection = [1, 1, 1, 1].permute(IdentityPermutation())
        collection[2] = 100
        XCTAssertEqual([1, 1, 100, 1], Array(collection))
    }

    func testRangeReplacementSameSize() {
        var collection = [5, 10, 15, 20].permute(SequencedPermuation(indices: [3, 1, 0, 2]))
        XCTAssertEqual([20, 10, 5, 15], Array(collection))
        collection.replaceRange(1...3, with: [2, 3, 4])
        XCTAssertEqual([20, 2, 3, 4], Array(collection))
    }
    
    func testRangeReplacementShorter() {
        var collection = [5, 10, 15, 20].permute(SequencedPermuation(indices: [3, 1, 0, 2]))
        XCTAssertEqual([20, 10, 5, 15], Array(collection))
        collection.replaceRange(1...3, with: [0, 1])
        XCTAssertEqual([1, 0, 20], collection.base)
        XCTAssertEqual([20, 0, 1], Array(collection))
    }
    
    func testRangeReplacementLonger() {
        var collection = [5, 10, 15, 20].permute(SequencedPermuation(indices: [3, 1, 0, 2]))
        XCTAssertEqual([20, 10, 5, 15], Array(collection))
        collection.replaceRange(1...2, with: [0, 1, 2, 3])
        XCTAssertEqual([1, 0, 15, 20, 2, 3], collection.base)
        XCTAssertEqual([20, 0, 1, 2, 3, 15], Array(collection))
    }
    
    func testMultipleReplacements() {
        var collection = [5, 10, 15, 20].permute(SequencedPermuation(indices: [3, 1, 0, 2]))
        XCTAssertEqual([20, 10, 5, 15], Array(collection))
        collection.replaceRange(1...2, with: [100, 200, 300, 400])
        XCTAssertEqual([20, 100, 200, 300, 400, 15], Array(collection))
        XCTAssertEqual([200, 100, 15, 20, 300, 400], collection.base)
        collection.replaceRange(0...2, with: [0])
        XCTAssertEqual([0, 300, 400, 15], Array(collection))
        XCTAssertEqual([15, 0, 300, 400], collection.base)
        collection.replaceRange(2...3, with: [-1, -2])
        XCTAssertEqual([0, 300, -1, -2], Array(collection))
        XCTAssertEqual([-2, 0, 300, -1], collection.base)
        collection.replaceRange(0..<0, with: [-100, -200, -300])
        XCTAssertEqual([-100, -200, -300, 0, 300, -1, -2], Array(collection))
        XCTAssertEqual([-2, 0, 300, -1, -100, -200, -300], collection.base)
    }
}
