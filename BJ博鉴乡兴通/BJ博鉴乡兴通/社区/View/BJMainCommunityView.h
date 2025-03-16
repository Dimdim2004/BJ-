//
//  BJMainCommunityView.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/22.
//

#import <UIKit/UIKit.h>
#import "BJCommunityUIColectionViewFlowLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJMainCommunityView : UIView
@property (nonatomic, strong) NSMutableArray<UICollectionView*> *flowViewArray;
@property (nonatomic, strong) UIScrollView* contentView;
@end

NS_ASSUME_NONNULL_END
