// Copyright 2014-present 650 Industries.
// Copyright 2014-present Andrew Toulouse.

#import <Foundation/Foundation.h>

@class BKDelta;

typedef BOOL (^delta_calculator_equality_test_t)(id a, id b);

extern const delta_calculator_equality_test_t BKDeltaCalculatorStrictEqualityTest;

@interface BKDeltaCalculator : NSObject

+ (instancetype)defaultCalculator;

+ (instancetype)deltaCalculatorWithEqualityTest:(delta_calculator_equality_test_t)equalityTest;

- (instancetype)initWithEqualityTest:(delta_calculator_equality_test_t)equalityTest;

/**
 Resolve differences between two versions of an array.
 
 @param oldArray the array representing the "old" version of the array
 @param newArray the array representing the "new" version of the array.
 @return A delta object containing NSIndexSets representing added, moved, removed, and unchanged elements.
 */
- (BKDelta *)deltaFromOldArray:(NSArray *)oldArray toNewArray:(NSArray *)newArray;

@end
