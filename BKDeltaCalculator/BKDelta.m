// Copyright 2014-present Andrew Toulouse.

#import <BKDeltaCalculator/BKDelta.h>

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

- (void)applyUpdatesToTableView:(UITableView *)tableView inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    NSMutableArray *removedIndexPaths = [NSMutableArray arrayWithCapacity:_removedIndices.count];
    [_removedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
        [removedIndexPaths addObject:indexPath];
    }];
    
    [tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:rowAnimation];
    
    NSMutableArray *addedIndexPaths = [NSMutableArray arrayWithCapacity:_addedIndices.count];
    [_addedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
        [addedIndexPaths addObject:indexPath];
    }];
    
    [tableView insertRowsAtIndexPaths:addedIndexPaths withRowAnimation:rowAnimation];
    
    [_movedIndexPairs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *fromIndex = [obj objectAtIndex:0], *toIndex = [obj objectAtIndex:1];
        NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[fromIndex unsignedIntegerValue] inSection:section];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[toIndex unsignedIntegerValue] inSection:section];
        [tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }];
}

- (void)applyUpdatesToCollectionView:(UICollectionView *)collectionView inSection:(NSUInteger)section
{
    NSMutableArray *removedIndexPaths = [NSMutableArray arrayWithCapacity:_removedIndices.count];
    [_removedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        [removedIndexPaths addObject:indexPath];
    }];

    [collectionView deleteItemsAtIndexPaths:removedIndexPaths];

    NSMutableArray *addedIndexPaths = [NSMutableArray arrayWithCapacity:_addedIndices.count];
    [_addedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        [addedIndexPaths addObject:indexPath];
    }];

    [collectionView insertItemsAtIndexPaths:addedIndexPaths];

    [_movedIndexPairs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *fromIndex = [obj objectAtIndex:0], *toIndex = [obj objectAtIndex:1];
        NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[fromIndex unsignedIntegerValue] inSection:section];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[toIndex unsignedIntegerValue] inSection:section];
        [collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }];
}
@end
