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


#import <Masonry.h>
#import "BJSearchBar.h"

@interface BJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BJSegmentControlTableViewCellDelegate>
{
    BJSegmentControlTableViewCell *_segmentCell;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BJSearchBar *searchBar;

@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic) UIView *stickyView;
@property (strong, nonatomic)NSArray *array;
@property (assign, nonatomic)BOOL isLocked;
@property ( nonatomic , assign ) CGFloat stickyViewBaseY ; // 吸顶临界点Y值
@end

@implementation BJHomePageViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupViews];
    [self setupStickyView];
    [self setupLineView];
    [self selectButtonAtIndex:0 animated:NO];
    
    _stickyViewBaseY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}
-(void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BJScrollViewTableViewCell class] forCellReuseIdentifier:@"ScrollViewCell"];
    [self.tableView registerClass:[BJButtonTableViewCell class] forCellReuseIdentifier:@"ButtonTableViewCell"];
    [self.tableView registerClass:[BJSegmentControlTableViewCell class] forCellReuseIdentifier:@"SegmentControlTableViewCell"];
    
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

//将BJScrollViewTableViewCell作为section0

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 223;
        case 1:
            return 120;
        case 2:
            return 800;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 56;
    } else {
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.searchBar = [[BJSearchBar alloc] init];
        self.searchBar.placeholder = @"搜索乡村/民俗/土货";
        self.searchBar.delegate = self;
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width - 20, 5);
        [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        return self.searchBar;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            BJScrollViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollViewCell"];
            cell.contentView.clipsToBounds = YES;
            cell.contentView.layer.cornerRadius = 15.0;
            NSArray *arr = @[@"1.png",@"2.png",@"3.png",@"4.png",@"5.png"];
            [cell configureWithTopStories:arr];
            return cell;
        }
        case 1: {
            BJButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
            cell.backgroundColor = [UIColor clearColor];
            [cell.btnToMap addTarget:self action:@selector(ToMap) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnToMyHometown addTarget:self action:@selector(ToMyHometown) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case 2: {
            BJSegmentControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentControlTableViewCell"];
            _segmentCell = cell;
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        default:
            return [[UITableViewCell alloc] init];
    }

}

-(void)ToMap {

    BJMapViewController *mapVC = [[BJMapViewController alloc] init];

    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}
-(void)ToMyHometown {

    BJMapViewController *mapVC = [[BJMapViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
    
    CGFloat offsetY = scrollView.contentOffset.y - 180.0;
    CGFloat threshold = 100.0;
    if (offsetY < 0) {
        appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0];
        return;
    }

    CGFloat alpha = offsetY / threshold;
    alpha = MAX(0, MIN(alpha, 1.0));
    
    appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
    [self updateStickyViewPosition] ;
}

- (void)updateStickyViewPosition {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    CGRect cellRectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect cellRectInWindow = [self.tableView convertRect:cellRectInTableView toView:self.view.window];
    
    CGFloat criticalY = _stickyViewBaseY - cellRectInWindow.origin.y;
    
    if (criticalY > 0) {
        self.stickyView.hidden = NO;
        _segmentCell.stickyView.hidden = YES;

        [self syncStickyViewStateFromSource:self.stickyView toTarget:_segmentCell.stickyView];
    } else {
        self.stickyView.hidden = YES;
        _segmentCell.stickyView.hidden = NO;
        
        [self syncStickyViewStateFromSource:_segmentCell.stickyView toTarget:self.stickyView];
    }
}


-(void)setupStickyView {
    
    self.stickyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 50, [UIScreen mainScreen].bounds.size.width, 40)];
    self.stickyView.backgroundColor = [UIColor whiteColor];
    self.stickyView.hidden = YES;
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
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.stickyView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.stickyView.bounds;
    layer.path = path.CGPath;
    self.stickyView.layer.mask = layer;
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
    
}

-(void)setupLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(17, 38, [UIScreen mainScreen].bounds.size.width / self.array.count - 15, 2)];
    self.lineView.clipsToBounds = YES;
    self.lineView.layer.cornerRadius = 1;
    self.lineView.backgroundColor = [UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1];
    [self.stickyView addSubview:self.lineView];
}

- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated {
    UIButton *targetBtn = [self.stickyView viewWithTag:100 + index];
    
    // 取消所有按钮选中
    [self.stickyView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
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


// 添加同步方法
- (void)syncStickyViewStateFromSource:(UIView *)sourceView toTarget:(UIView *)targetView {
    // 1. 获取当前选中按钮索引
    __block NSInteger selectedIndex = -1;
    [sourceView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]] && ((UIButton *)obj).selected) {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    
    if (selectedIndex == -1) return;
    NSLog(@"%d",selectedIndex);
    // 2. 同步按钮状态
    UIButton *targetButton = targetView.subviews[selectedIndex];
    [targetView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            if (idx == selectedIndex) {
                UIButton *btn = (UIButton *)obj;
                btn.selected = YES;
                btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } else {
                UIButton *btn = (UIButton *)obj;
                btn.selected = NO;
                btn.transform = CGAffineTransformIdentity;
            }
                
            
        }
    }];
    UIView *targetLineView = nil;
    if ([targetView isEqual:self.stickyView]) {
        targetLineView = self.lineView;
    } else {
        targetLineView = _segmentCell.lineView;
    }
    CGRect lineFrame = targetLineView.frame;
    lineFrame.origin.x = targetButton.frame.origin.x + 17;
    targetLineView.frame = lineFrame;
    
    
    
}

@end
