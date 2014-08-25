// Copyright 2014-present Andrew Toulouse.

#import "BKDelta.h"

@implementation BKDelta

+ (instancetype)deltaWithAddedIndices:(NSIndexSet *)addedIndices
                       removedIndices:(NSIndexSet *)removedIndices
                      movedIndexPairs:(NSArray *)movedIndexPairs
                     unchangedIndices:(NSIndexSet *)unchangedIndices
{
    return [[self alloc] initWithAddedIndices:addedIndices
                               removedIndices:removedIndices
                              movedIndexPairs:movedIndexPairs
                             unchangedIndices:unchangedIndices];
}

- (instancetype)initWithAddedIndices:(NSIndexSet *)addedIndices
                      removedIndices:(NSIndexSet *)removedIndices
                     movedIndexPairs:(NSArray *)movedIndexPairs
                    unchangedIndices:(NSIndexSet *)unchangedIndices
{
    if (self = [super init]) {
        _addedIndices = [addedIndices copy];
        _removedIndices = [removedIndices copy];
        _movedIndexPairs = [movedIndexPairs copy];
        _unchangedIndices = [unchangedIndices copy];
    }
    return self;
}
@end
