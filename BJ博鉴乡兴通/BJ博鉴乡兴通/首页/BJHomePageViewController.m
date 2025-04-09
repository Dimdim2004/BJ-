//
//  BJHomePageViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJHomePageViewController.h"
#import "BJMapViewController.h"
#import "BJScrollViewTableViewCell.h"
#import "BJSegmentControlTableViewCell.h"
#import "BJMyHometownViewController.h"
#import "BJSearchBarTableViewCell.h"
#import "BJCountryModel.h"
#import "BJNotFoundViewController.h"
#import "BJNetworkingManger.h"
#import "BJScaleTableViewCell.h"
#import "BJDynamicView.h"
#import <Masonry.h>

@interface BJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    BJSegmentControlTableViewCell *_segmentCell;
}


@property (nonatomic,strong) UITableView *tableView;

@property (strong, nonatomic)UIView *lineView;
@property (strong, nonatomic) UIView *stickyView;
@property (strong, nonatomic)NSArray *array;
@property (assign, nonatomic)BOOL isLocked;
@property (nonatomic, assign) CGFloat stickyViewBaseY ; // 吸顶临界点Y值
@property (nonatomic, strong) UIButton *btnToMyHometown;
@property (nonatomic, strong) UIButton *btnToMap;

@property (nonatomic, assign) CGFloat maxOffsetY;

@end

@implementation BJHomePageViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isLocked = NO;
    _stickyViewBaseY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height - 4;
    [self setupViews];
    [self setupBtn];
    _maxOffsetY = 400;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

-(void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BJSearchBarTableViewCell class] forCellReuseIdentifier:@"BarTableViewCell"];
    [self.tableView registerClass:[BJScaleTableViewCell class] forCellReuseIdentifier:@"ScaleTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UItableViewCell"];
    [self.tableView registerClass:[BJSegmentControlTableViewCell class] forCellReuseIdentifier:@"SegmentControlTableViewCell"];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
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

#pragma mark - 按钮方法

-(void)ToMap {
    BJMapViewController *mapVC = [[BJMapViewController alloc] init];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)ToMyHometown {
    BOOL flag = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    if (!flag) {
        BJNotFoundViewController *notFoundVC = [[BJNotFoundViewController alloc] init];
        [self.navigationController pushViewController:notFoundVC animated:YES];
    } else {
        [[BJNetworkingManger sharedManger] loadCountryInfoWithCountryID:10 WithSuccess:^(BJCountryModel * _Nonnull countryModel) {
            BJMyHometownViewController *hometownVC = [[BJMyHometownViewController alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                hometownVC.countryModel = countryModel;
            });
            
            [self.navigationController pushViewController:hometownVC animated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"加载失败");
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            
            BJSearchBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarTableViewCell"];
            return cell;
        }
        case 1: {
            BJScaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];

            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UItableViewCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 3: {
            BJSegmentControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentControlTableViewCell"];
            _segmentCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            for (BJDynamicView *view in _segmentCell.dynamicViews) {
                view.scrollDelegate =self;
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        default:
            return [[UITableViewCell alloc] init];
    }
    
}

#pragma mark - 手势冲突处理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView layoutIfNeeded];
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y - 100.0;
        CGFloat threshold = 180.0;
        CGFloat alpha = offsetY / threshold;
        alpha = MAX(0, MIN(alpha, 1.0));
        
        UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
        appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
       
        if (scrollView.contentOffset.y >= _maxOffsetY) {
            [scrollView setContentOffset:CGPointMake(0, _maxOffsetY) animated:NO];
            for (BJDynamicView *view in _segmentCell.dynamicViews) {
                view.tableView.scrollEnabled = YES;
            }
        }
    } else {
        if (scrollView.contentOffset.y <= 0) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            for (BJDynamicView *view in _segmentCell.dynamicViews) {
                view.tableView.scrollEnabled = NO;
            }
            self.tableView.scrollEnabled = YES;
        }
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



-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
}


-(void)setupBtn {
    
    UIView *buttonContainer = [UIView new];
    [self.tableView addSubview:buttonContainer];
    
    
    
    // 创建按钮公共配置
    void (^buttonConfig)(UIButton *) = ^(UIButton *btn) {
        
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 20; // 圆角半径
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        
        btn.layer.shadowRadius = 5;
        btn.layer.shadowOffset =  CGSizeMake(1, 1);
        btn.layer.shadowOpacity = 0.8;
        btn.layer.shadowColor =  [UIColor grayColor].CGColor;


        btn.titleLabel.font = [UIFont fontWithName:@"Joyfonts-QinglongGB-Flash-Black" size:26];
        btn.titleLabel.numberOfLines = 2;
        [btn setTitleColor:[UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1]
                 forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    };
    
    // 配置"我的家乡"按钮
    _btnToMyHometown = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnToMyHometown setImage:[UIImage imageNamed:@"toMyHometown.png"] forState:UIControlStateNormal];
    [_btnToMyHometown setTitle:@"我的家乡" forState:UIControlStateNormal];
    buttonConfig(_btnToMyHometown);
    
    // 配置"地图导航"按钮
    _btnToMap = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnToMap setImage:[UIImage imageNamed:@"toMap.png"] forState:UIControlStateNormal];
    [_btnToMap setTitle:@"地图导航" forState:UIControlStateNormal];
    buttonConfig(_btnToMap);
    
    [buttonContainer addSubview:_btnToMyHometown];
    [buttonContainer addSubview:_btnToMap];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@150); // 按钮高度
        make.left.right.equalTo(self.tableView);
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(320);
    }];
    
    
    [_btnToMyHometown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer).offset(-95);
        make.height.equalTo(@140);
        make.width.equalTo(@180);
        make.centerY.equalTo(buttonContainer);
    }];
    
    [_btnToMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonContainer).offset(95);
        make.centerY.equalTo(buttonContainer);
        make.height.equalTo(@140);
        make.width.equalTo(@180);;
    }];
    
    [_btnToMap addTarget:self action:@selector(ToMap) forControlEvents:UIControlEventTouchUpInside];
    [_btnToMyHometown addTarget:self action:@selector(ToMyHometown) forControlEvents:UIControlEventTouchUpInside];
}



@end
