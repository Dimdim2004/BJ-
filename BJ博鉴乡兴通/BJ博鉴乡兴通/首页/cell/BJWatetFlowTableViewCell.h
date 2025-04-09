//
//  BJWatetFlowTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/4.
//

#import <UIKit/UIKit.h>
@class BJMyHometownViewController;
NS_ASSUME_NONNULL_BEGIN

@interface BJWatetFlowTableViewCell : UITableViewCell
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, weak)BJMyHometownViewController *scrollDelegate;

@end

NS_ASSUME_NONNULL_END
