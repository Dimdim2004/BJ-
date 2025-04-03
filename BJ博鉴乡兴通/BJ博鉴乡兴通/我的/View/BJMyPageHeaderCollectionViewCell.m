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
        self.attentaionLabel = [[UILabel alloc] init];
        self.fansLabel = [[UILabel alloc] init];
        
        
        self.likeLabel = [[UILabel alloc] init];
        self.fansLabel.font = [UIFont systemFontOfSize:14];
        self.likeLabel.font = [UIFont systemFontOfSize:14];
        self.attentaionLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_iconView];
        [self addSubview:_nameLabel];
        [self addSubview:_attentaionLabel];
        [self addSubview:_likeLabel];
        [self addSubview:_fansLabel];
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
        [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@60);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fansLabel.mas_right).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@60);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        [self.attentaionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.likeLabel.mas_right).offset(10);
            make.width.equalTo(@70);
            make.height.equalTo(@60);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(45);
        }];
        self.fansLabel.text = @"2\n粉丝个数";
        self.fansLabel.textAlignment = NSTextAlignmentCenter;
        self.attentaionLabel.textAlignment = NSTextAlignmentCenter;
        self.likeLabel.textAlignment = NSTextAlignmentCenter;
        self.attentaionLabel.text = @"2\n关注";
        self.likeLabel.text = @"2\n获赞数量";
        self.fansLabel.text = [self.fansLabel.text stringByReplacingOccurrencesOfString:@"\\n" withString:self.fansLabel.text];
        self.fansLabel.numberOfLines = 0;
        self.attentaionLabel.numberOfLines = 0;
        self.likeLabel.numberOfLines = 0;
        
        [self dealWithLabel:self.fansLabel withText:@"粉丝个数" withCount:2];
        [self dealWithLabel:_likeLabel withText:@"获赞数量" withCount:2];
        [self dealWithLabel:self.attentaionLabel withText:@"关注" withCount:2];
        
        
        self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.darftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.darftButton setImage:[UIImage imageNamed:@"draft.png"] forState:UIControlStateNormal];
        self.hometownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shoppingCraftButtton =[UIButton buttonWithType:UIButtonTypeCustom];
        self.shopButton.backgroundColor = UIColor.whiteColor;
        self.darftButton.backgroundColor = UIColor.whiteColor;
        self.hometownButton.backgroundColor = UIColor.whiteColor;
        self.shoppingCraftButtton.backgroundColor = UIColor.whiteColor;
        
        self.darftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.shopButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.hometownButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.shoppingCraftButtton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.shopButton];
        [self addSubview:self.darftButton];
        [self addSubview:self.hometownButton];
        [self addSubview:self.shoppingCraftButtton];
        
        self.shopButton.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 26);
        self.darftButton.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 26);
        self.hometownButton.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 26);
        self.shoppingCraftButtton.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 26);
        
        self.shopButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 10, 0);
        self.darftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 10, 0);
        self.hometownButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 10, 0);
        self.shoppingCraftButtton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 10, 0);
        
        self.shopButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.darftButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.hometownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.shoppingCraftButtton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        
        [self.shopButton setTitle:@"订单" forState:UIControlStateNormal];
        [self.darftButton setTitle:@"草稿箱" forState:UIControlStateNormal];
        [self.hometownButton setTitle:@"家乡" forState:UIControlStateNormal];
        [self.shoppingCraftButtton setTitle:@"购物车" forState:UIControlStateNormal];
        [self.shopButton setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
        [self.darftButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        [self.hometownButton setImage:[UIImage imageNamed:@"hometown.png"] forState:UIControlStateNormal];
        [self.shoppingCraftButtton setImage:[UIImage imageNamed:@"shopcraft.png"] forState:UIControlStateNormal];
        [self.shopButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.darftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.hometownButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.shoppingCraftButtton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.height.equalTo(@(60));
            make.width.equalTo(@100);
            make.top.equalTo(@220);
        }];
        [self.darftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shopButton.mas_right).offset(5);
            make.height.equalTo(@(60));
            make.width.equalTo(@100);
            make.top.equalTo(@220);
        }];
        [self.hometownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.darftButton.mas_right).offset(5);
            make.height.equalTo(@(60));
            make.width.equalTo(@100);
            make.top.equalTo(@220);
        }];
        [self.shoppingCraftButtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hometownButton.mas_right).offset(5);
            make.height.equalTo(@(60));
            make.width.equalTo(@100);
            make.top.equalTo(@220);
        }];
    }
    return self;
}
- (void)dealWithLabel:(UILabel*)label withText:(NSString*)text withCount:(NSInteger)count {
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSString* string= [NSString stringWithFormat:@"%ld\n%@", count, text];
    NSString* numString = [NSString stringWithFormat:@"%ld", count];
    NSInteger numCount = numString.length;
    NSMutableAttributedString* attributtedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributtedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attributtedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, numCount)];
    label.attributedText = attributtedText;
}
- (void)addButtonToScrollView {
    
    self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.darftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.darftButton setImage:[UIImage imageNamed:@"draft.png"] forState:UIControlStateNormal];
    UIColor* myColor = [UIColor colorWithRed:83 / 255.0 green:88 / 255.0 blue:86 / 255.0 alpha:1];
    
    self.hometownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shoppingCraftButtton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.shopButton.backgroundColor = UIColor.whiteColor;
    self.darftButton.backgroundColor = UIColor.whiteColor;
    self.hometownButton.backgroundColor = UIColor.whiteColor;
    self.shoppingCraftButtton.backgroundColor = UIColor.whiteColor;
    
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
