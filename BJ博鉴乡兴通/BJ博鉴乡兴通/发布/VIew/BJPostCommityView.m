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
    self.mainView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, self.frame.size.height - 100) style:UITableViewStylePlain];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    self.mainView.estimatedRowHeight = 100;
    self.mainView.rowHeight = UITableViewAutomaticDimension;
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.equalTo(@45);
        make.top.equalTo(@60);
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

@end
