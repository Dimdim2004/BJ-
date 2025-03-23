//
//  BJScaleTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJScaleTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)NSMutableArray *imageArray;
@end

NS_ASSUME_NONNULL_END
