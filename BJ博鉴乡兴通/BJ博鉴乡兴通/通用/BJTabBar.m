//
//  BJTabBar.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJTabBar.h"
#import "Masonry.h"

@implementation BJTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.tintColor = [UIColor systemGreenColor];
        [self setupCenterButton];
    }
    return self;
}

- (void)setupCenterButton {
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.backgroundColor = [UIColor whiteColor];

    [self.centerButton setImage:[UIImage imageNamed:@"jiahao.png"] forState:UIControlStateNormal];
    [self addSubview:self.centerButton];
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:view];
//    
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.width.equalTo(self);
//        make.height.equalTo(@1);
//    }];
}


//布局中间按钮
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self bringSubviewToFront:self.centerButton];
    
    CGFloat width = self.frame.size.width;
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat centerButtonSize = 50;
    self.centerButton.frame = CGRectMake((width - centerButtonSize) / 2,
                                         -centerButtonSize / 2 + 10,
                                         centerButtonSize ,
                                         centerButtonSize);
    self.centerButton.layer.cornerRadius = (centerButtonSize) / 2;
    self.centerButton.clipsToBounds = YES;
    [self.centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat tabBarItemWidth = width / 5;
    NSInteger index = 0;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == 2) {

                index++;
            }
            CGRect frame = subview.frame;
            frame.origin.x = index * tabBarItemWidth;
            frame.size.width = tabBarItemWidth;
            subview.frame = frame;
            index++;
        }
    }
}

//中心按钮点击的方法
- (void)centerButtonAction:(UIButton *)sender {
    NSLog(@"button is clicked");

}

//使得中心按钮超过tabBar的部分被点击也能进行相应
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint pointTemp = [self convertPoint:point toView:_centerButton];
    if ([_centerButton pointInside:pointTemp withEvent:event]) {
        return YES;
    }
    //否则返回默认的操作
    return [super pointInside:point withEvent:event];
}

@end
