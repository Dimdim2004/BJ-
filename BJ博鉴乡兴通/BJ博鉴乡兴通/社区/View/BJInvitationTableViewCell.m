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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([reuseIdentifier isEqualToString:@"comments"]) {
        
        self.timeLabel = [[UILabel alloc] init];
        self.textView = [[UITextView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.headLabel = [[UILabel alloc] init];
        
        self.headLabel.font = [UIFont boldSystemFontOfSize:16];
        self.image = [[UIImageView alloc] init];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setImage:[UIImage imageNamed:@"pinglun-2.png"] forState:UIControlStateNormal];
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton setImage:[UIImage imageNamed:@"dianzan-2.png"] forState:UIControlStateNormal];
        //[self.likeButton setTitle: forState:]
        self.textView.editable = NO; // 确保 TextView 只读
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:16];
        self.textView.textColor = UIColor.blackColor;
        //self.textView.textContainerInset = UIEdgeInsetsZero;
        //self.textView.textContainer.lineFragmentPadding = 0;
        self.image.layer.masksToBounds = YES;
        
        self.commentText.editable = NO;
        self.commentText.scrollEnabled = NO;
        self.commentText.font = [UIFont systemFontOfSize:16];
        self.commentText.textColor = UIColor.lightGrayColor;
        
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = UIColor.lightGrayColor;
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_textView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_commentButton];
        [self.contentView addSubview:_likeButton];
        [self.contentView addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@100);
        }];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.headLabel.mas_bottom).offset(20);
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
            make.top.equalTo(self.image.mas_bottom);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(_timeLabel.mas_top);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
            make.left.equalTo(self.textView).offset(5);
            make.width.equalTo(@120);
        }];
        
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(self.timeLabel.mas_bottom);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.equalTo(@20);
        }];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(self.timeLabel.mas_bottom);
            make.right.equalTo(_commentButton.mas_left).offset(-30);
            make.width.equalTo(@30);
        }];
        //_likeButton.imageView.frame = CGRectMake(0, 0, 20, 20);
        //CGFloat spacing = 5.0;
        CGFloat spacing = 10.0; // 图片和文字之间的间距

        // 获取图片和文字的尺寸
        CGSize imageSize = _likeButton.imageView.frame.size;
        CGSize titleSize = _likeButton.titleLabel.frame.size;

        // 设置文本和图片的偏移
        _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - spacing, 0, imageSize.width);
        _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, -titleSize.width);

        
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
