//
//  SegmentControlTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//



#import "BJSegmentControlTableViewCell.h"
#import <Masonry.h>


@interface BJSegmentControlTableViewCell ()<UIScrollViewDelegate>

@property (assign, nonatomic)BOOL isLocked;
@property (strong, nonatomic)UIView *segmentView;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic)NSArray *array;
@end


@implementation BJSegmentControlTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isLocked = NO;
        [self setupViews];
        [self setupLineView];
        [self setupScrollView];
        [self selectButtonAtIndex:0 animated:NO];
    }
    return self;
}

-(void)setupViews {
    
    self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.segmentView];
    self.array = @[@"关注", @"周边", @"精选",@"陕西省"];
   
    for(int i = 0; i < self.array.count; i++) {
        NSString *name = self.array[i];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / self.array.count;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 40)];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1] forState:UIControlStateSelected];
        button.tag = 100 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentView addSubview:button];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.segmentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.segmentView.bounds;
    layer.path = path.CGPath;
    self.segmentView.layer.mask = layer;

}

-(void)setupLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(17, 38, [UIScreen mainScreen].bounds.size.width / self.array.count - 15, 2)];
    self.lineView.clipsToBounds = YES;
    self.lineView.layer.cornerRadius = 1;
    self.lineView.backgroundColor = [UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1];
    [self.segmentView addSubview:self.lineView];
}
-(void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.array.count, 0);
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - 按钮点击处理
-(void)buttonClicked:(UIButton*)sender {
    self.isLocked = YES;
    [self.segmentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.selected = (btn == sender);
            if (btn != sender) {
                btn.transform = CGAffineTransformIdentity;
            }
        }
    }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.lineView.frame;
        frame.origin.x = sender.frame.origin.x + 17;
        self.lineView.frame = frame;
    }];
    
    CGFloat offsetX = (sender.tag - 100) * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark - ScrollView联动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLocked) return;
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    

    [self selectButtonAtIndex:currentPage animated:YES];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
   self.isLocked = NO;
}

#pragma mark - 公共方法
- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIButton *targetBtn = [self.segmentView viewWithTag:100 + index];
    
    // 取消所有按钮选中
    [self.segmentView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            btn.selected = (btn == targetBtn);
            btn.transform = (btn == targetBtn) ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity;
        }
    }];
    
    // 移动横线
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.frame = CGRectMake(targetBtn.frame.origin.x + 17, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
        }];
    } else {
        self.lineView.frame = CGRectMake(targetBtn.frame.origin.x + 17, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }
}




@end
