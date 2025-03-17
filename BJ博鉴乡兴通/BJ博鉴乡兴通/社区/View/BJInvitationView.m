//
//  BJInvitationView.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import "BJInvitationView.h"
#import "BJInvitationTableViewCell.h"
#import "BJInvitationHeaderTableViewCell.h"
#import "Masonry.h"
@implementation BJInvitationView
- (void)setUI {
    self.backgroundColor = UIColor.whiteColor;
    self.mainView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mainView];
    self.mainView.estimatedRowHeight = 100;
    self.mainView.rowHeight = UITableViewAutomaticDimension;
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
