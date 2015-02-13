// Copyright 2014-present Andrew Toulouse.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKDelta : NSObject

@property (nonatomic, copy, readonly) NSIndexSet *addedIndices;
@property (nonatomic, copy, readonly) NSIndexSet *removedIndices;
@property (nonatomic, copy, readonly) NSArray *movedIndexPairs;
@property (nonatomic, copy, readonly) NSIndexSet *unchangedIndices;

- (void)applyUpdatesToTableView:(UITableView *)tableView inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)applyUpdatesToCollectionView:(UICollectionView *)collectionView inSection:(NSUInteger)section;

@end
