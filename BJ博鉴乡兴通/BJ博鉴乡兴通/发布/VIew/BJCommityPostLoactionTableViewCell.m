//
//  BJCommityPostLoactionTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCommityPostLoactionTableViewCell.h"
#import "Masonry.h"
@implementation BJCommityPostLoactionTableViewCell

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
    if ([self.reuseIdentifier isEqualToString:@"loaction"]) {
        self.titleView = [[UITextField alloc] init];
        self.titleView.text = @"关联到村";
        self.titleView.frame = CGRectMake(40, 5, 100, 30);
        [self.contentView addSubview:self.titleView];
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = [UIImage imageNamed:@"didian.png"];
        self.iconView.frame = CGRectMake(10, 7.5, 25, 25);
        
        [self.contentView addSubview:self.iconView];
    } else if ([self.reuseIdentifier isEqualToString:@"friendRange"]) {
        self.titleView = [[UITextField alloc] init];
        self.titleView.text = @"公开可见";
        self.titleView.frame = CGRectMake(40, 5, 100, 30);
        [self.contentView addSubview:self.titleView];
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = [UIImage imageNamed:@"jiesuo-2.png"];
        self.iconView.frame = CGRectMake(10, 7.5, 25, 25);
        
        [self.contentView addSubview:self.iconView];
    } else if ([self.reuseIdentifier isEqualToString:@"preView"]) {
        UIButton* likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton* starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton* commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"xihuan-3.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"shoucang-5.png"] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"pinglun-3.png"] forState:UIControlStateNormal];
        [likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
        [starButton setTitle:@"收藏" forState:UIControlStateNormal];
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [likeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [starButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [commentButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.contentView addSubview:likeButton];
        [self.contentView addSubview:starButton];
        [self.contentView addSubview:commentButton];
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(likeButton.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(commentButton.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
    }
    return self;
}
@end
