//
//  BJCommunityViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import <UIKit/UIKit.h>
#import "BJMainCommunityView.h"
@class BJCommityModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJCommunityViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDataSourcePrefetching>
@property (nonatomic, strong) BJMainCommunityView* iView;
@property (nonatomic, strong) NSMutableArray* model;
@end

NS_ASSUME_NONNULL_END
