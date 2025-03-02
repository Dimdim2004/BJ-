//
//  BJCommunityViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJCommunityViewController.h"
#import "BJCommityCollectionViewCell.h"
#import "BJInvitationViewController.h"
@interface BJCommunityViewController ()

@end

@implementation BJCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
    self.iView.FlowView.delegate = self;
    self.iView.FlowView.dataSource = self;
    [self.iView.FlowView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    [self.view addSubview:self.iView];
    // Do any additional setup after loading the view.
}
- (void)setNavgationBar {
    UINavigationBarAppearance* apperance = [[UINavigationBarAppearance alloc] init];
    apperance.shadowColor = [UIColor clearColor];
    apperance.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.standardAppearance = apperance;
    self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    
}
- (void)setSegmentControl {
    UIView* constantView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 120, 44)];
    NSArray* title = @[@"推荐", @"附近", @"关注"];
    for (int i = 0; i < 3; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 60, 0, 60, 44);
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];\
        if (i == 1) {
            button.selected = YES;
        }
        [constantView addSubview:button];
    }
    self.navigationItem.titleView = constantView;
}
- (void)setupLine {
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[BJInvitationViewController alloc] init] animated:YES];
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
