//
//  BJMyPageView.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageView : UIView
@property (nonatomic, strong) UICollectionView* collectionView;
- (void)setUI:(NSArray*)heightAry andSectionCount:(NSInteger)sectionCount itemCount:(NSInteger)itemCount;
@end

NS_ASSUME_NONNULL_END
