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
        self.backgroundColor = UIColor.whiteColor;
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [self addSubview:self.activity];
        [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
        }];
    }
    return self;
}
- (void)startLoading:(BOOL)isLoading {
    if (isLoading) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}
@end
