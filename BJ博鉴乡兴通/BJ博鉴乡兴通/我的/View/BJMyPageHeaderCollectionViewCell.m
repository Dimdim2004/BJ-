//
//  BJMyPageCollectionViewCell.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/25.
//

#import "BJMyPageHeaderCollectionViewCell.h"
#import "Masonry/Masonry.h"
@implementation BJMyPageHeaderCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor* myColor = [UIColor colorWithRed:48 / 255.0 green:50 / 255.0 blue:57 / 255.0 alpha:1];
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.iconView = [[UIImageView alloc] init];
        self.iconView.layer.masksToBounds = YES;
        self.iconView.layer.cornerRadius = 45;
        self.nameLabel = [[UILabel alloc] init];
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 180, 393, 80)];
        self.scrollView.contentSize = CGSizeMake(393 * 1.2, 0);
        self.scrollView.bouncesVertically = NO;
        self.scrollView.bouncesHorizontally = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.fansButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_iconView];
        [self addSubview:_nameLabel];
        [self addSubview:_attentionButton];
        [self addSubview:_fansButton];
        [self addSubview:_likeButton];
        [self addSubview:_scrollView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.height.equalTo(@90);
            make.top.equalTo(self).offset(30);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.width.equalTo(@120);
            make.height.equalTo(@40);
            make.centerY.equalTo(self.iconView);
        }];
        [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@30);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fansButton.mas_right).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@30);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.likeButton.mas_right).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@30);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        [self.fansButton setTitle:@"粉丝\n 1" forState:UIControlStateNormal];
        [self.attentionButton setTitle:@"关注数量\n 2" forState:UIControlStateNormal];
        [self.likeButton setTitle:@"获赞数量\n 2" forState:UIControlStateNormal];
        [self.fansButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.likeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self addButtonToScrollView];
    }
    return self;
}
- (void)addButtonToScrollView {
    
    self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.darftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.darftButton setImage:[UIImage imageNamed:@"draft.png"] forState:UIControlStateNormal];
    UIColor* myColor = [UIColor colorWithRed:83 / 255.0 green:88 / 255.0 blue:86 / 255.0 alpha:1];
    
    self.hometownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shoppingCraftButtton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.shopButton.backgroundColor = myColor;
    self.darftButton.backgroundColor = myColor;
    self.hometownButton.backgroundColor = myColor;
    self.shoppingCraftButtton.backgroundColor = myColor;
    
    self.darftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.shopButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.hometownButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.shoppingCraftButtton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.scrollView addSubview:self.shopButton];
    [self.scrollView addSubview:self.darftButton];
    [self.scrollView addSubview:self.hometownButton];
    [self.scrollView addSubview:self.shoppingCraftButtton];
    [self.shopButton setTitle:@"购物" forState:UIControlStateNormal];
    [self.darftButton setTitle:@"草稿箱" forState:UIControlStateNormal];
    [self.hometownButton setTitle:@"我的家乡" forState:UIControlStateNormal];
    [self.shoppingCraftButtton setTitle:@"购物车" forState:UIControlStateNormal];
    [self.shopButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.darftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.hometownButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.shoppingCraftButtton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@100);
        make.centerY.equalTo(self.scrollView);
    }];
    [self.darftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopButton.mas_right).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@90);
        make.centerY.equalTo(self.scrollView);
    }];
    [self.hometownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.darftButton.mas_right).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@90);
        make.centerY.equalTo(self.scrollView);
    }];
    [self.shoppingCraftButtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hometownButton.mas_right).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@90);
        make.centerY.equalTo(self.scrollView);
    }];
}
@end
