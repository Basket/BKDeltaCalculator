// Copyright 2014-present 650 Industries. All rights reserved.

#import "BKDeltaCalculator.h"

NSString * const BKValueChangeAddedKey = @"BKValueChangeAddedKey";
NSString * const BKValueChangeMovedKey = @"BKValueChangeMovedKey";
NSString * const BKValueChangeRemovedKey = @"BKValueChangeRemovedKey";
NSString * const BKValueChangeUnchangedKey = @"BKValueChangeUnchangedKey";

@implementation BKDeltaCalculator

+ (NSDictionary *)resolveDifferencesBetweenOldArray:(NSArray *)oldArray newArray:(NSArray *)newArray
{
    // Index set for objects...
    NSMutableIndexSet *unchangedIndices = [NSMutableIndexSet indexSet]; // ...with identical positions
    NSMutableArray *movedIndices = [NSMutableArray array]; // ...which moved, in pairs [old index, new index]
    NSMutableIndexSet *addedNewIndices = [NSMutableIndexSet indexSet]; // ...which were added, new index
    NSMutableIndexSet *removedOldIndices = [NSMutableIndexSet indexSet]; // ...which were deleted, old index

    // Unchanged
    for (NSUInteger index = 0; index < oldArray.count; index++) {
        if (index >= newArray.count) { // Bounds check. No unchanged indices possible when out of range
            break;
        }
        if (oldArray[index] == newArray[index]) { // using _exact_ equivalence
            [unchangedIndices addIndex:index];
        }
    }

    // Moved and added
    for (NSUInteger newIndex = 0; newIndex < newArray.count; newIndex++) {
        if ([unchangedIndices containsIndex:newIndex]) {
            continue;
        }

        id newItem = newArray[newIndex];
        NSUInteger oldIndex = [oldArray indexOfObjectIdenticalTo:newItem];
        if (!oldArray || oldIndex == NSNotFound) {
            [addedNewIndices addIndex:newIndex];
        } else {
            [movedIndices addObject:@[@(oldIndex), @(newIndex)]];
        }
    }

    // Removed
    for (NSUInteger oldIndex = 0; oldIndex < oldArray.count; oldIndex++) {
        id oldItem = oldArray[oldIndex];
        NSUInteger newIndex = [newArray indexOfObjectIdenticalTo:oldItem];
        if (newIndex == NSNotFound) {
            [removedOldIndices addIndex:oldIndex];
        }
    }

    return @{
             BKValueChangeUnchangedKey: [unchangedIndices copy],
             BKValueChangeMovedKey: [movedIndices copy],
             BKValueChangeAddedKey: [addedNewIndices copy],
             BKValueChangeRemovedKey: [removedOldIndices copy],
             };
}

@end
