//
//  BJLocationViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/31.
//

#import "BJLocationViewController.h"
#import "BJlocationModel.h"
#import <Masonry.h>
@interface BJLocationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation BJLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"周边村庄";
    [self setupUI];
}

- (void)setModels:(NSArray<BJLocationModel *> *)models {
    _models = models;
    [self.tableView reloadData];
}

-(void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infoTableView"];
    [self.view addSubview:self.tableView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"周边村庄";
    self.titleLabel.font = [UIFont fontWithName:@"Joyfonts-QinglongGB-Flash-Black" size:26];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(0, 80, self.view.bounds.size.width, 50);
    self.tableView.tableHeaderView = self.titleLabel;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoTableView"];
    cell.textLabel.text = self.models[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    if([self.delegate respondsToSelector:@selector(sendBackLocation:)]) {
        [self.delegate sendBackLocation:self.models[indexPath.row].location];
    }
}
@end
