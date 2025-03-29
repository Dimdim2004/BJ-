//
//  BJMyPageFootReusableView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/28.
//

#import "BJMyPageFootReusableView.h"

@implementation BJMyPageFootReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"我的喜欢";
        [self addSubview:_titleLabel];
    }
    return self;
}
@end
