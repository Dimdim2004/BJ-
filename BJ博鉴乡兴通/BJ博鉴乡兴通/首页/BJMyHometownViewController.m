//
//  BJMyHometownViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import "BJMyHometownViewController.h"
#import <Masonry.h>
#import "BJCountryModel.h"
#import "SDWebImage.h"
#import "BJCountryInfoTableViewCell.h"

@interface BJMyHometownViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;
@property(assign, nonatomic) CGFloat imageHeight;
@property(strong, nonatomic) UIImageView *headerImageView;
@property(strong, nonatomic) UIButton *leftButton;

@end

@implementation BJMyHometownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageHeight = 250;
    [self setupViews];
}

-(void)setupViews {
    self.navigationController.navigationBar.titleTextAttributes = @{
           NSForegroundColorAttributeName: [UIColor whiteColor]
       };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[BJCountryInfoTableViewCell class] forCellReuseIdentifier:@"CountryInfoCell"];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.imageHeight)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"4.png"];
    

    [self.tableView insertSubview:self.headerImageView atIndex:0];
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.imageHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    

    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)leftButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCountryModel:(BJCountryModel *)countryModel {
    
    self.title = countryModel.name;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:countryModel.image]];
    _countryModel = countryModel;
    
    [self.tableView reloadData];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BJCountryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryInfoCell"];
        [cell configureWithModel:self.countryModel];
        return cell;
    } else {

        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TempCell"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    } else {
        return 800;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
      if (offsetY < 0) {
          self.headerImageView.frame = CGRectMake(offsetY, offsetY, scrollView.bounds.size.width - offsetY * 2, self.imageHeight - offsetY);
      } else {
          self.headerImageView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, self.imageHeight);
      }
    CGFloat threshold = 100.0;
    CGFloat alpha = offsetY / threshold;
    alpha = MAX(0, MIN(alpha, 1.0));
    
    UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
    appearance.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
    if (alpha >= 0.5) {
        appearance.titleTextAttributes = @{
               NSForegroundColorAttributeName: [UIColor blackColor]
           };
           [self.leftButton setTintColor:[UIColor blackColor]];
       } else {
           appearance.titleTextAttributes = @{
               NSForegroundColorAttributeName: [UIColor whiteColor]
           };
           [self.leftButton setTintColor:[UIColor whiteColor]];
       }
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
}


@end
