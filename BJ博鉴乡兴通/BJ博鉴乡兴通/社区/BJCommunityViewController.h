//
//  BJCommunityViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import <UIKit/UIKit.h>
#import "BJMainCommunityView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJCommunityViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) BJMainCommunityView* iView;
@end

NS_ASSUME_NONNULL_END
