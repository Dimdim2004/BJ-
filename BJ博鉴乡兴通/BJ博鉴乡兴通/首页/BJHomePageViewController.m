//
//  BJHomePageViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJHomePageViewController.h"
#import "BJMapViewController.h"

@interface BJHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation BJHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BJMapViewController *mapVC = [[BJMapViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2.png"]];
    logoImageView.frame = CGRectMake(0, 0, 130, 30);
    logoImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = logoImageView;
}




@end
