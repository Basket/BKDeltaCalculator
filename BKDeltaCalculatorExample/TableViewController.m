// Copyright 2015-present Andrew Toulouse.

#import "TableViewController.h"

#import "BKDelta.h"
#import "BKDeltaCalculator.h"

@interface TableViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger number;
@end
@implementation TableViewCell
@end

@implementation TableViewController {
    NSArray *_items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mutableItems = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        [mutableItems addObject:@(i)];
    }
    _items = [mutableItems copy];
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [_items[indexPath.row] description];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    [tableView beginUpdates];
    BKDelta *delta = [[BKDeltaCalculator defaultCalculator] deltaFromOldArray:_items toNewArray:newItems];
    [delta applyUpdatesToTableView:tableView inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    _items = [newItems copy];
    [tableView endUpdates];
}

@end
