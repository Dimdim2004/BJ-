//
//  SegmentControlTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//


#import "BJSegmentControlTableViewCell.h"
#import <Masonry.h>
#import "BJDynamicModel.h"
#import "BJDynamicTableViewCell.h"
#import "BJDynamicView.h"



@interface BJSegmentControlTableViewCell ()<UIScrollViewDelegate,BJDynamicTableViewCellDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic)BOOL isLocked;
@property (strong, nonatomic)NSArray *array;
@property (strong, nonatomic)NSArray<BJDynamicModel *> *dynamicModel;
@property (strong, nonatomic)UIView *lineView;

@end


@implementation BJSegmentControlTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isLocked = NO;
        self.dynamicViews = [[NSMutableArray alloc] init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupStickyView];
        [self setupLineView];
        [self selectButtonAtIndex:0 animated:NO];
        [self setupModel];
        [self setupScrollView];

        
    }
    return self;
}

-(void)setupStickyView {
    
    self.stickyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    self.stickyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.stickyView];
    
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
        [self.stickyView addSubview:button];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.stickyView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.stickyView.bounds;
    layer.path = path.CGPath;
    self.stickyView.layer.mask = layer;
}



- (void)buttonClicked:(UIButton*)sender {
    self.isLocked = YES;
    [self.stickyView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
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
    
    NSInteger tag = sender.tag - 100;
    [self setScrollViewOffsetWithTag:tag animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLocked = NO;
    });
}



-(void)setupLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(17, 38, [UIScreen mainScreen].bounds.size.width / self.array.count - 15, 2)];
    self.lineView.clipsToBounds = YES;
    self.lineView.layer.cornerRadius = 1;
    self.lineView.backgroundColor = [UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1];
    [self.stickyView addSubview:self.lineView];
}

- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.isLocked) {
        return;
    }
    UIButton *targetBtn = [self.stickyView viewWithTag:100 + index];
    
    
    [self.stickyView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            btn.selected = (btn == targetBtn);
            btn.transform = (btn == targetBtn) ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity;
        }
    }];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.frame = CGRectMake(targetBtn.frame.origin.x + 17, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
        }];
    } else {
        self.lineView.frame = CGRectMake(targetBtn.frame.origin.x + 17, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }
}

-(void)setupModel {
    BJDynamicModel *model = [[BJDynamicModel alloc] init];
    model.userName = @"旅行日记";
    model.avatarUrl = @"https://example.com/avatars/travel_diary.jpg";
    model.content = @"刚完成环青海湖骑行，全程360公里，蓝天白云和油菜花海交织的美景让人忘却疲惫🚴♀️！";
    model.images = @[
        @"1.png",
        @"2.png",
        @"3.png"
    ];
    model.numofLikes = @"12";
    model.numofComment = @"5";
    model.numofShare = @"3";
    model.timeText = @"3小时前";
    model.isLiked = NO;
    self.dynamicModel = @[model, model, model,model,model];
}

- (void) setScrollViewOffsetWithTag:(NSInteger)tag animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(tag  * self.scrollView.frame.size.width, 0) animated:animated];
}
-(void)setupScrollView {
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.scrollView];
    
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stickyView.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    UIView *containerView = [UIView new];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    

    UIView *previousView = nil;
    for (int i = 0; i < 4; i++) {;
        BJDynamicView *dynamicView = [[BJDynamicView alloc] initWithDynamicModel:self.dynamicModel];
        
        dynamicView.tag = 100 + i;
        dynamicView.backgroundColor = [UIColor whiteColor];
        [self.dynamicViews addObject:dynamicView];
        [containerView addSubview:dynamicView];
        [dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(containerView);
            make.width.equalTo(self.scrollView);
            
            if (previousView) {
                make.left.equalTo(previousView.mas_right);
            } else {
                make.left.equalTo(containerView);
            }
        }];
        
        previousView = dynamicView;
    }
    

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousView);
    }];

    // 设置内容区域右边界
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousView.mas_right);
    }];
    

    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}


#pragma mark - ScrollView联动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLocked) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIButton *targetBtn = [self.stickyView viewWithTag:100 + currentPage];
    [self.stickyView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            btn.selected = (btn == targetBtn);
            btn.transform = (btn == targetBtn) ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity;
        }
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(targetBtn.frame.origin.x + 17, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }];
    if ([self.delegate respondsToSelector:@selector(segmentCell:didScrollToPage:)]) {
        [self.delegate segmentCell:self didScrollToPage:currentPage];
    }
}

-(BJDynamicView*)currentPageRollwithSet {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger currentPage = (NSInteger)(self.scrollView.contentOffset.x / pageWidth);
    BJDynamicView* view = self.dynamicViews[currentPage];
    return view;
}

-(NSInteger)getCurrentPage {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger currentPage = (NSInteger)(self.scrollView.contentOffset.x / pageWidth);
    return currentPage;
}
@end
