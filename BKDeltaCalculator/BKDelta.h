// Copyright 2014-present Andrew Toulouse.

#import <Foundation/Foundation.h>

@interface BKDelta : NSObject

@property (nonatomic, copy, readonly) NSIndexSet *addedIndices;
@property (nonatomic, copy, readonly) NSIndexSet *removedIndices;
@property (nonatomic, copy, readonly) NSArray *movedIndexPairs;
@property (nonatomic, copy, readonly) NSIndexSet *unchangedIndices;

@end
