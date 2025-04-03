//
//  BJMyPageFootReusableView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/28.
//

#import "BJMyPageHeaderReusableView.h"

@implementation BJMyPageHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.bounds;
        layer.path = path.CGPath;
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.path = path.CGPath;
        borderLayer.lineWidth = 1.0;
        borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:borderLayer];
        borderLayer.borderWidth = 0.2;
        borderLayer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.mask = layer;
        [self.layer addSublayer:borderLayer];
        self.backgroundColor = UIColor.whiteColor;
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"我的作品";
        [self addSubview:_titleLabel];
    }
    return self;
}
@end
