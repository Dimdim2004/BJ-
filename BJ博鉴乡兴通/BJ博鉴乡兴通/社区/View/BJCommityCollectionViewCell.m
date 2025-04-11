//
//  BJCommityCollectionViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/29.
//

#import "BJCommityCollectionViewCell.h"
#import "Masonry.h"
@implementation BJCommityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        self.profileView = [[UIImageView alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.label.numberOfLines = 2;
        self.label.font = [UIFont systemFontOfSize:17];
        self.label.lineBreakMode = YES;
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameLabel.text = @"123444";
        self.profileView.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
        self.nameLabel.font = [UIFont systemFontOfSize:10];
        self.nameLabel.textColor = UIColor.lightGrayColor;
        self.profileView.layer.masksToBounds = YES;
        self.profileView.layer.cornerRadius = 30 / 2;
        
        [self.likeButton setImage:[UIImage imageNamed:@"likeSmall.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"likeSelected.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_profileView];
        [self.contentView addSubview:_likeButton];
        [self.contentView addSubview:_nameLabel];
        
       
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(6);
            make.right.equalTo(self.contentView).offset(-6);
            make.bottom.equalTo(self.contentView).offset(-40);
            make.height.greaterThanOrEqualTo(@20); 
        }];
        [self.profileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileView.mas_right).offset(5);
            make.width.equalTo(@120);
            make.height.equalTo(@20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.width.equalTo(@45);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        self.likeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).priorityHigh();
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.label.mas_top).offset(-10);
        }];
        self.label.text = @"标题部分标题";
    }
    return self;
}


@end
