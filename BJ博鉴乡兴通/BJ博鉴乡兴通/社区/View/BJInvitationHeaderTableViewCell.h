//
//  BJInvitationHeaderTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJInvitationHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong) UIScrollView* headScrollerView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIPageControl* mypage;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* label;
- (void)addImageToScrollerView:(NSArray<UIImage*>*)imageAry;
- (void)addUrlImageToScrollerView:(NSArray<NSString*>*)imageAry;
@end

NS_ASSUME_NONNULL_END
