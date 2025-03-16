//
//  TopContentView.m
//  Daily
//
//  Created by nanxun on 2024/10/22.
//

#import "BJInvitationTopContentView.h"

@implementation BJInvitationTopContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.contentLabel = [[UILabel alloc] init];
        self.imageView = [[UIImageView alloc] init];
        self.contentLabel.textColor = [UIColor colorWithRed:198/255.0 green:203/255.0 blue:208/255.0 alpha:1];
        self.titleLabel.textColor = UIColor.whiteColor;
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@(self.bounds.size.width));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(10);
            make.top.equalTo(self.imageView).offset(-10);
            make.height.equalTo(@80);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.right.equalTo(self.titleLabel);
            make.bottom.equalTo(self);
        }];
        
        
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
