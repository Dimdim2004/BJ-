//
//  BJCountryDynamicTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import <UIKit/UIKit.h>
@class BJCommityModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJCountryDynamicTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (strong, nonatomic)NSMutableArray <BJCommityModel *>* commityArray;

@end

NS_ASSUME_NONNULL_END
