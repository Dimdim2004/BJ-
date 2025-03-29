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
@property (nonatomic, strong) UICollectionView* mainView;
@property (nonatomic, strong) UIScrollView* contentView;
- (void)setUIWithHeightAry:(NSArray<NSNumber*>*)heightAry andSectionCount:(NSInteger)sectionCount itemCount:(NSInteger)itemCount;
@end

NS_ASSUME_NONNULL_END
