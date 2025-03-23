//
//  BJHomePageViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJHomePageViewController.h"
#import "BJMapViewController.h"
#import "BJScrollViewTableViewCell.h"
#import "BJButtonTableViewCell.h"
#import "BJSegmentControlTableViewCell.h"
#import "BJMyHometownViewController.h"
#import "BJSearchBarTableViewCell.h"


#import "BJDynamicView.h"
#import <Masonry.h>

@interface BJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BJSegmentControlTableViewCellDelegate,BJDynamicViewDelegate,UIGestureRecognizerDelegate>
{
    BJSegmentControlTableViewCell *_segmentCell;
}


@property (nonatomic,strong) UITableView *tableView;

@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic) UIView *stickyView;
@property (strong, nonatomic)NSArray *array;
@property (assign, nonatomic)BOOL isLocked;
@property ( nonatomic , assign ) CGFloat stickyViewBaseY ; // 吸顶临界点Y值
@end

@implementation BJHomePageViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isLocked = NO;
    _stickyViewBaseY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height - 4;
    [self setupViews];
    [self setupStickyView];
    [self setupLineView];
    [self selectButtonAtIndex:0 animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(handleEnableOuterScroll:)
                                                   name:@"ShouldEnableOuterScroll"
                                                 object:nil];
    
}

- (void)handleEnableOuterScroll:(NSNotification *)notification {
    self.tableView.scrollEnabled = YES;

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

-(void)setupStickyView {
    
    self.stickyView = [[UIView alloc] initWithFrame:CGRectMake(0, _stickyViewBaseY - 5, [UIScreen mainScreen].bounds.size.width, 40)];
    self.stickyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.stickyView];
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
}

-(void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = YES;
    self.tableView.panGestureRecognizer.delegate = self.tableView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BJSearchBarTableViewCell class] forCellReuseIdentifier:@"BarTableViewCell"];
    [self.tableView registerClass:[BJScrollViewTableViewCell class] forCellReuseIdentifier:@"ScrollViewCell"];
    [self.tableView registerClass:[BJButtonTableViewCell class] forCellReuseIdentifier:@"ButtonTableViewCell"];
    [self.tableView registerClass:[BJSegmentControlTableViewCell class] forCellReuseIdentifier:@"SegmentControlTableViewCell"];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self; // 这里的self是实现了代理方法的对象
    [self.tableView addGestureRecognizer:panGesture];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2.png"]];
    logoImageView.frame = CGRectMake(0, 0, 130, 30);
    logoImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = logoImageView;
    
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0];
    appearance.shadowColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backView.png"]];
    imageView.frame = CGRectMake(0, -130, self.view.frame.size.width, 180);
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageView.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                             (id)[UIColor clearColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.5, @1.0];
    
    imageView.layer.mask = gradientLayer;
    
    [self.tableView addSubview:imageView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 10;
        case 1:
            return 223;
        case 2:
            return 120;
        case 3:
            return [UIScreen mainScreen].bounds.size.height - _stickyViewBaseY;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            
            BJSearchBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarTableViewCell"];
            return cell;
        }
        case 1: {
            BJScrollViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *arr = @[@"1.png",@"2.png",@"3.png",@"4.png",@"5.png"];
            [cell configureWithTopStories:arr];
            return cell;
        }
        case 2: {
            BJButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            [cell.btnToMap addTarget:self action:@selector(ToMap) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnToMyHometown addTarget:self action:@selector(ToMyHometown) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case 3: {
            BJSegmentControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentControlTableViewCell"];
            _segmentCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            for (BJDynamicView *view in _segmentCell.dynamicViews) {
                view.delegate = self;
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        default:
            return [[UITableViewCell alloc] init];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
#pragma mark - 按钮方法

-(void)ToMap {
    
    BJMapViewController *mapVC = [[BJMapViewController alloc] init];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}
-(void)ToMyHometown {
    
    BJMyHometownViewController *mapVC = [[BJMyHometownViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 手势冲突处理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y - 100.0;
        CGFloat threshold = 180.0;
        CGFloat alpha = offsetY / threshold;
        alpha = MAX(0, MIN(alpha, 1.0));
        
        UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
        appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        [self updateStickyViewPosition];
    }
}

- (void)updateStickyViewPosition {
    CGFloat offsetY = self.tableView.contentOffset.y;
    NSIndexPath *section3IndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    CGRect section3Rect = [self.tableView rectForSection:section3IndexPath.section];
    CGFloat criticalY = section3Rect.origin.y - _stickyViewBaseY + 30;
    
    if (offsetY >= criticalY) {
        [self.tableView setContentOffset:CGPointMake(0, section3Rect.origin.y - _stickyViewBaseY + 40) animated:NO];
        self.stickyView.hidden = NO;
        _segmentCell.stickyView.hidden = YES;
        NSInteger page = [_segmentCell getCurrentPage];
        [self selectButtonAtIndex:page animated:NO];
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        BJDynamicView *currentView = [_segmentCell currentPageRollwithSet];
        currentView.tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
        for (BJDynamicView *view in _segmentCell.dynamicViews) {
            view.tableView.scrollEnabled = YES;
        }
        
    } else {
        self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.stickyView.hidden = YES;
        
        _segmentCell.stickyView.hidden = NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [pan translationInView:self.tableView];
    BJDynamicView *view = [_segmentCell currentPageRollwithSet];
    if(self.tableView.scrollEnabled && translation.y > 0 && view.tableView.scrollEnabled) {
        for (BJDynamicView *view in _segmentCell.dynamicViews) {
            view.tableView.scrollEnabled = NO;
        }
    } else if(self.tableView.scrollEnabled && translation.y < 0 && view.tableView.scrollEnabled){
        self.tableView.scrollEnabled = NO;
    }
    return YES;
}



-(void)handlePan:(UIGestureRecognizer *)gestureRecognizer {
    
}




-(void)buttonClicked:(UIButton*)sender {
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
    [_segmentCell setScrollViewOffsetWithTag:tag animated:YES];
    
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


//点击方法的处理
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




#pragma mark - BJSegmentControlTableViewCellDelegate
- (void)segmentCell:(BJSegmentControlTableViewCell *)cell didScrollToPage:(NSInteger)page {
    if (self.isLocked) {
        return;
    }
    UIButton *targetBtn = [self.stickyView viewWithTag:100 + page];
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
    
}

- (void)segmentControlDidStartInteraction {
    self.isLocked = YES;
}

- (void)segmentControlDidEndInteraction {
    self.isLocked = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
