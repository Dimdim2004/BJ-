//
//  BJCommityFootReusableView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/28.
//

#import "BJCommityFootReusableView.h"
#import "Masonry/Masonry.h"
@implementation BJCommityFootReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor* mycolor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
        self.backgroundColor = mycolor;
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [self addSubview:self.activity];
        [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
    }
    return self;
}
- (void)startLoading:(BOOL)isLoading {
    if (isLoading) {
        NSLog(@"123213开始加载");
        [self.activity startAnimating];
    } else {
        NSLog(@"123123停止加载");
        [self.activity stopAnimating];
    }
}
- (void)endLoading {
    [self.activity removeFromSuperview];
    UILabel* label = [[UILabel alloc] init];
    label.text = @"没有更多内容";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
}
@end
