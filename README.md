# BKDeltaCalculator
Lightweight Objective-C library to transform a pair of collections into sets of changes. These changes can be applied to UITableView and UICollectionView instances in batched updates, providing a more declarative way to update your views.


## Installation

BKDeltaCalculator is available through [CocoaPods](http://cocoapods.org/). To install it, simply add the following line to your Podfile:
```ruby
pod "BKDeltaCalculator"
```

## Usage

BKDeltaCalculator compares two arrays and computes the delta between them, represented by a BKDelta object. The two arrays may contain the old and new models to display in a table view or collection view, for example.
```objc
BKDeltaCalculator *calculator = [BKDeltaCalculator defaultCalculator];
BKDelta *delta = [calculator deltaFromOldArray:oldArray toNewArray:newArray];
```

### Table and Collection Views

You can apply BKDelta to a UITableView or UICollectionView when the old array represents the currently displayed cells and the new array represents the cells to display next. Used a batched update to smoothly animate the cells.
```objc
// With a UITableView:
[tableView beginUpdates];
BKDelta *delta = [[BKDeltaCalculator defaultCalculator] deltaFromOldArray:_items toNewArray:newItems];
[delta applyUpdatesToTableView:tableView inSection:0 withRowAnimation:UITableViewRowAnimationFade];
_items = [newItems copy];
[tableView endUpdates];

// With a UICollectionView:
[collectionView performBatchUpdates:^{
  [delta applyUpdatesToCollectionView:collectionView inSection:0];
  _items = [newItems copy];
} completion:nil];
```

### Equality Checks

By default, BKDeltaCalculator compares items in the two arrays using strict equality checks that compare object identities. You can also provide a custom comparator:
```objc
BKDeltaCalculator calculator = [BKDeltaCalculator deltaCalculatorWithEqualityTest:^(id a, id b) {
  return (a == b) || [a isEqual:b];
}];
```
