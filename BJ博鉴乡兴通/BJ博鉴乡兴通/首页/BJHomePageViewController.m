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

#import <Masonry.h>
#import "BJSearchBar.h"

@interface BJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BJSearchBar *searchBar;
@end

@implementation BJHomePageViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupViews];
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
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BJScrollViewTableViewCell class] forCellReuseIdentifier:@"ScrollViewCell"];
    [self.tableView registerClass:[BJButtonTableViewCell class] forCellReuseIdentifier:@"ButtonTableViewCell"];
    
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2.png"]];
    logoImageView.frame = CGRectMake(0, 0, 130, 30);
    logoImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = logoImageView;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar.subviews.firstObject insertSubview:backgroundView atIndex:0];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
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
    return 2;
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

@end
