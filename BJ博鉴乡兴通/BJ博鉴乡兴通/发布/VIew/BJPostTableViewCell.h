//
//  BJPostTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPostTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextView* titleLabel;
@property (nonatomic, strong) UITextView* contentLabel;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, strong) UIImageView* icon;
@end

NS_ASSUME_NONNULL_END
