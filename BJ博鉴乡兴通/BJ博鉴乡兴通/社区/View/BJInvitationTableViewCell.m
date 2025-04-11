//
//  BJInvitationTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import "BJInvitationTableViewCell.h"
#import "Masonry.h"
@implementation BJInvitationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)prepareForReuse {
    [super prepareForReuse];
    self.commentButton.hidden = YES;
    
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentButton.mas_top).offset(-5).priorityHigh();
        make.left.equalTo(self.textView).offset(5);
        make.width.equalTo(@50);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([reuseIdentifier isEqualToString:@"comments"]) {
        
        self.timeLabel = [[UILabel alloc] init];
        self.textView = [[UITextView alloc] init];
        self.textView.selectable = NO;
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.headLabel = [[UILabel alloc] init];
        
        self.headLabel.font = [UIFont boldSystemFontOfSize:16];
        self.image = [[UIImageView alloc] init];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setTitle:@"——展开下方评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [self.replyButton setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton setImage:[UIImage imageNamed:@"likeSmall.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"likeSelected.png"] forState:UIControlStateSelected];
        
        //[self.likeButton setTitle: forState:]
        self.textView.editable = NO; // 确保 TextView 只读
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:16];
        self.textView.textColor = UIColor.blackColor;
        self.textView.backgroundColor = UIColor.clearColor;
        //self.textView.textContainerInset = UIEdgeInsetsZero;
        //self.textView.textContainer.lineFragmentPadding = 0;
        self.image.layer.masksToBounds = YES;
        
        self.commentText.editable = NO;
        self.commentText.scrollEnabled = NO;
        self.commentText.font = [UIFont systemFontOfSize:16];
        self.commentText.textColor = UIColor.lightGrayColor;
        
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = UIColor.lightGrayColor;
        [self.contentView addSubview:_replyButton];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_textView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_commentButton];
        [self.contentView addSubview:_likeButton];
        [self.contentView addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10).priorityHigh();
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@100);
        }];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.headLabel.mas_bottom).offset(20).priorityHigh();
            make.height.equalTo(@40);
            make.width.equalTo(@40);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.mas_right).offset(10);
            make.top.equalTo(self.headLabel.mas_bottom).offset(30);
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).priorityHigh();
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(_timeLabel.mas_top);
        }];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@20);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@130);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.commentButton.mas_top).offset(-5).priorityHigh();
            make.left.equalTo(self.textView).offset(5);
            make.width.equalTo(@50);
        }];
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_right).offset(5).priorityHigh();
            make.bottom.equalTo(self.timeLabel);
            make.width.equalTo(@40);
            make.top.equalTo(_timeLabel);
        }];
        
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.bottom.equalTo(self.timeLabel.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-30);
            make.width.equalTo(@80);
        }];
        //_likeButton.imageView.frame = CGRectMake(0, 0, 20, 20);
        //CGFloat spacing = 5.0;
//        _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, -10); // 图片稍微向左下角偏移
//        _likeButton.titleEdgeInsets = UIEdgeInsetsMake(-30, 20, 0, 0);
        [_likeButton setTitle:@"  " forState:UIControlStateNormal];
        [_likeButton setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        //_likeButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        //_likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //_likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.image.layer.cornerRadius = 20;
        
        //[self.textView sizeToFit];
    }
    return self;
}

@end
