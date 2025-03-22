//
//  BJInvitationTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJInvitationTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIImageView* image;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UITextView* commentText;
@property (nonatomic, strong) UIButton* likeButton;
@property (nonatomic, strong) UIButton* commentButton;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UILabel* headLabel;
@property (nonatomic, strong) UIButton* replyButton;
@end

NS_ASSUME_NONNULL_END
