// Copyright 2014-present Andrew Toulouse.

#import <BKDeltaCalculator/BKDelta.h>

@interface BKDelta ()

+ (instancetype)deltaWithAddedIndices:(NSIndexSet *)addedIndices
                       removedIndices:(NSIndexSet *)removedIndices
                      movedIndexPairs:(NSArray *)movedIndexPairs
                     unchangedIndices:(NSIndexSet *)unchangedIndices;

- (instancetype)initWithAddedIndices:(NSIndexSet *)addedIndices
                      removedIndices:(NSIndexSet *)removedIndices
                     movedIndexPairs:(NSArray *)movedIndexPairs
                    unchangedIndices:(NSIndexSet *)unchangedIndices;

@end
