// Copyright 2014-present 650 Industries. All rights reserved.

@import Foundation;

NSString * const BKValueChangeAddedKey;
NSString * const BKValueChangeMovedKey;
NSString * const BKValueChangeRemovedKey;
NSString * const BKValueChangeUnchangedKey;

/**
 `BKDeltaCalculator` takes two arrays as input and outputs a dictionary with the following keys:

 * `BKValueChangeAddedKey`: an index set in the new array's index space representing elements that were added to the new array.
 * `BKValueChangeMovedKey`: an array containing an index set in the old array's index space followed by an index set of equivalent size in the new array's index space, both representing elements that changed position.
 * `BKValueChangeRemovedKey`: an index set in the old array's index space representing elements that were removed from the old array.
 * `BKValueChangeUnchangedKey`: an index set with indices representing elements in the same position in both arrays
 */
@interface BKDeltaCalculator : NSObject

/**
 Resolve differences between two versions of an array.
 
 @param oldArray the array representing the "old" version of the array
 @param newArray the array representing the "new" version of the array.
 @return A dictionary containing NSIndexSets representing added, moved, removed, and unchanged elements.
 */
+ (NSDictionary *)resolveDifferencesBetweenOldArray:(NSArray *)oldArray newArray:(NSArray *)newArray;

@end
