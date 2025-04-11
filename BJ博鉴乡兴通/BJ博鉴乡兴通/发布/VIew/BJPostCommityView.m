//
//  BJPostCommityView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/9.
//

#import "BJPostCommityView.h"
#import "Masonry.h"
@implementation BJPostCommityView
- (void)setUI {
    self.backgroundColor = UIColor.whiteColor;
    self.mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 500) style:UITableViewStylePlain];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    self.mainView.estimatedRowHeight = 100;
    self.mainView.rowHeight = UITableViewAutomaticDimension;
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    self.mainView.scrollEnabled = NO;
    [self addSubview:self.backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.equalTo(@45);
        make.top.equalTo(@60);
    }];
    self.draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.draftButton setTitle:@"草稿箱" forState:UIControlStateNormal];
    self.draftButton.titleLabel.font = [UIFont systemFontOfSize: 10];
    self.draftButton.titleEdgeInsets = UIEdgeInsetsMake(28, -30, 0, 0);
    self.draftButton.imageEdgeInsets = UIEdgeInsetsMake(-10, 10, 0, 0);
    _draftButton.layer.masksToBounds = YES;
    _draftButton.layer.cornerRadius = 25;
    [_draftButton setImage:[UIImage imageNamed:@"caogaoxiang.png"] forState:UIControlStateNormal];
    [_draftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    _draftButton.backgroundColor = UIColor.whiteColor;
    [self addSubview:_draftButton];
    [_draftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(self).offset(-30);
    }];
    self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    self.previewButton.layer.masksToBounds = YES;
    self.previewButton.layer.cornerRadius = 25;
    self.previewButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.previewButton.titleEdgeInsets = UIEdgeInsetsMake(28, -30, 0, 0);
    self.previewButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 10, 0, 0);
    [_previewButton setImage:[UIImage imageNamed:@"yulan.png"] forState:UIControlStateNormal];
    _previewButton.backgroundColor = UIColor.whiteColor;
    [_previewButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self addSubview:_previewButton];
    [_previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.draftButton.mas_right).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(self).offset(-30);
    }];
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_postButton];
    [_postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.previewButton.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self).offset(-30);
        make.height.equalTo(@50);
    }];
    UIColor* buttonColor = [UIColor colorWithRed:43.0 / 255.0 green:95.0 / 255.0 blue:51 / 255.0 alpha:1];
    self.postButton.layer.masksToBounds = YES;
    self.postButton.layer.cornerRadius = 10;
    self.postButton.backgroundColor = buttonColor;
    [self.postButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

@end
