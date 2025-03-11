//
//  BJPostView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import "BJPostView.h"
#import "Masonry.h"
@implementation BJPostView
- (void)setUI {
    self.commityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.commityButton.backgroundColor = UIColor.redColor;
    self.privateButton.backgroundColor = UIColor.blueColor;
    [self.privateButton setTitle:@"个人动态" forState:UIControlStateNormal];
    [self.commityButton setTitle:@"图文社区" forState:UIControlStateNormal];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [self addSubview:_commityButton];
    [self addSubview:_privateButton];
    [self addSubview:_iconView];
    [self addSubview:_nameLabel];
    [self addSubview:_backButton];
    [_commityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.equalTo(@100);
        make.top.equalTo(@300);
    }];
    [_privateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.height.equalTo(@100);
        make.top.equalTo(@300);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.equalTo(@45);
        make.top.equalTo(@60);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.equalTo(@100);
        make.top.equalTo(@200);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.height.equalTo(@100);
        make.top.equalTo(@0);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
