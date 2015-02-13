// Copyright 2015-present Andrew Toulouse.

#import "CollectionViewController.h"

#import "BKDelta.h"
#import "BKDeltaCalculator.h"

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) NSUInteger number;
@end
@implementation CollectionViewCell
@end

@implementation CollectionViewController {
    NSArray *_items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mutableItems = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        [mutableItems addObject:@(i)];
    }
    _items = [mutableItems copy];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1337];
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.tag = 1337;
        [cell.contentView addSubview:label];
    }
    label.text = [_items[indexPath.row] description];
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(cell.bounds), CGRectGetMidY(cell.bounds));
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Shuffle
    NSMutableArray *newItems = [_items mutableCopy];
    NSUInteger count = newItems.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = newItems.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [newItems exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    // Delete randomly
    for (NSUInteger i = 0; i < 2; ++i) {
        NSInteger remainingCount = newItems.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [newItems exchangeObjectAtIndex:newItems.count - 1 withObjectAtIndex:exchangeIndex];
        NSLog(@"REMOVED %@", [newItems lastObject]);
        [newItems removeLastObject];
    }
    
    // Add randomly
    for (NSUInteger i = 0; i < 3; ++i) {
        NSNumber *max = [[newItems sortedArrayUsingSelector: @selector(compare:)] lastObject];
        [newItems addObject:@([max unsignedIntegerValue] + 1)];
        NSLog(@"ADDED %@", [newItems lastObject]);
        NSInteger remainingCount = newItems.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [newItems exchangeObjectAtIndex:newItems.count - 1 withObjectAtIndex:exchangeIndex];
    }
    
    BKDelta *delta = [[BKDeltaCalculator defaultCalculator] deltaFromOldArray:_items toNewArray:newItems];
    [collectionView performBatchUpdates:^{
        [delta applyUpdatesToCollectionView:collectionView inSection:0];
        _items = [newItems copy];
    } completion:nil];

    return YES;
}

@end
