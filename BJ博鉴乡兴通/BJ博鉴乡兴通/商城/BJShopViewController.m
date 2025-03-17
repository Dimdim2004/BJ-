//
//  BJShopViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJShopViewController.h"
#import "<#header#>"
@interface BJShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@end

@implementation BJShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

-(void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
