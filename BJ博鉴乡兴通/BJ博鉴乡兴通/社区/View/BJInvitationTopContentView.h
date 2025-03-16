//
//  TopContentView.h
//  Daily
//
//  Created by nanxun on 2024/10/22.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJInvitationTopContentView : UIView
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* contentLabel;

@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* label;
// 在.h文件中添加属性


@end

NS_ASSUME_NONNULL_END
