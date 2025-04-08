//
//  BJMyPageCollectionViewCell.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageHeaderCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* iconView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* attentaionLabel;
@property (nonatomic, strong) UILabel* fansLabel;
@property (nonatomic, strong) UILabel* likeLabel;
@property (nonatomic, strong) UIButton* shopButton;
@property (nonatomic, strong) UIButton* hometownButton;
@property (nonatomic, strong) UIButton* shoppingCraftButtton;
@property (nonatomic, strong) UIButton* darftButton;
@property (nonatomic, strong) UIScrollView* scrollView;
- (void)dealWithLabel:(UILabel*)label withText:(NSString*)text withCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
