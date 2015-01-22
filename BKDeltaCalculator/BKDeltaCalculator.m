// Copyright 2014-present 650 Industries.
// Copyright 2014-present Andrew Toulouse.

#import "BKDeltaCalculator.h"

#import "BKDelta.h"
#import "BKDelta_Internal.h"

const delta_calculator_equality_test_t BKDeltaCalculatorStrictEqualityTest = ^BOOL(id a, id b) {
    return a == b;
};

@implementation BKDeltaCalculator {
    delta_calculator_equality_test_t _equalityTest;
}

+ (instancetype)defaultCalculator
{
    static BKDeltaCalculator *INSTANCE;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[BKDeltaCalculator alloc] init];
    });

    return INSTANCE;
}

+ (instancetype)deltaCalculatorWithEqualityTest:(delta_calculator_equality_test_t)equalityTest
{
    return [[BKDeltaCalculator alloc] initWithEqualityTest:equalityTest];
}

- (instancetype)init
{
    return [self initWithEqualityTest:BKDeltaCalculatorStrictEqualityTest];
}

- (instancetype)initWithEqualityTest:(delta_calculator_equality_test_t)equalityTest
{
    if (self = [super init]) {
        _equalityTest = equalityTest;
    }
    return self;
}

- (BKDelta *)deltaFromOldArray:(NSArray *)oldArray toNewArray:(NSArray *)newArray
{
    // Index set for objects...
    NSMutableIndexSet *unchangedIndices = [NSMutableIndexSet indexSet]; // ...with identical positions
    NSMutableIndexSet *addedNewIndices = [NSMutableIndexSet indexSet]; // ...which were added, new index
    NSMutableIndexSet *removedOldIndices = [NSMutableIndexSet indexSet]; // ...which were deleted, old index
    // Indices of items that moved, in pairs [from index, to index], after removing and adding items
    NSMutableArray *movedIndices = [NSMutableArray array];

    // Unchanged
    for (NSUInteger index = 0; index < oldArray.count; index++) {
        if (index >= newArray.count) { // Bounds check. No unchanged indices possible when out of range
            break;
        }
        if (_equalityTest(oldArray[index], newArray[index])) {
            [unchangedIndices addIndex:index];
        }
    }

    // Removed
    for (NSUInteger oldIndex = 0; oldIndex < oldArray.count; oldIndex++) {
        id oldItem = oldArray[oldIndex];
        NSUInteger newIndex = [newArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return _equalityTest(obj, oldItem);
        }];
        if (newIndex == NSNotFound) {
            [removedOldIndices addIndex:oldIndex];
        }
    }

    // Added
    for (NSUInteger newIndex = 0; newIndex < newArray.count; newIndex++) {
        if ([unchangedIndices containsIndex:newIndex]) {
            continue;
        }

        id newItem = newArray[newIndex];
        NSUInteger oldIndex = [oldArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return _equalityTest(obj, newItem);
        }];
        if (!oldArray || oldIndex == NSNotFound) {
            [addedNewIndices addIndex:newIndex];
        }
    }

    // Moved (after removing and adding)
    NSMutableArray *simulatedArray = [oldArray mutableCopy];
    [simulatedArray removeObjectsAtIndexes:removedOldIndices];
    [simulatedArray insertObjects:[newArray objectsAtIndexes:addedNewIndices] atIndexes:addedNewIndices];
    for (NSUInteger fromIndex = 0; fromIndex < simulatedArray.count; fromIndex++) {
        if ([unchangedIndices containsIndex:fromIndex]) {
            continue;
        }

        id movedItem = simulatedArray[fromIndex];
        NSUInteger toIndex = [newArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return _equalityTest(obj, movedItem);
        }];
        NSAssert(toIndex != NSNotFound, @"Item %@ is missing from the new array", movedItem);
        // An item may have the same index but not be in the unchanged index set if it is new
        if (fromIndex != toIndex) {
            [movedIndices addObject:@[@(fromIndex), @(toIndex)]];
        }
    }

    return [BKDelta deltaWithAddedIndices:[addedNewIndices copy]
                           removedIndices:[removedOldIndices copy]
                          movedIndexPairs:[movedIndices copy]
                         unchangedIndices:[unchangedIndices copy]];
}

@end
