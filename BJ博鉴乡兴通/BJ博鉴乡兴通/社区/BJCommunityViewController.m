//
//  BJCommunityViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJCommunityViewController.h"
#import "BJCommityCollectionViewCell.h"
#import "BJInvitationViewController.h"
@interface BJCommunityViewController () {
    UIView* _indicatorLine;
    BOOL _isLocked;
}

@end

@implementation BJCommunityViewController

- (void)viewDidLoad {
    _isLocked = NO;
    [super viewDidLoad];
    _isLocked = NO;
    self.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
    self.iView.contentView.delegate = self;
    for (int i = 0; i < 3; i++) {
        self.iView.flowViewArray[i].delegate = self;
        self.iView.flowViewArray[i].dataSource = self;
        [self.iView.flowViewArray[i] registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    [self.view addSubview:self.iView];
    [self setNavgationBar];
    [self setSegmentControl];
    [self setupLine];
    // Do any additional setup after loading the view.
}
- (void)setNavgationBar {
    UINavigationBarAppearance* apperance = [[UINavigationBarAppearance alloc] init];
    apperance.shadowColor = [UIColor clearColor];
    apperance.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.standardAppearance = apperance;
    self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    NSString* string = @"santiaogang.png";
    apperance.backgroundColor = UIColor.whiteColor;
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:string]]];
    self.navigationItem.leftBarButtonItem = leftButton;
}
- (void)setSegmentControl {
    UIView* constantView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 120, 44)];
    NSArray* title = @[@"推荐", @"附近", @"关注"];
    for (int i = 0; i < 3; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 60 + 60, 0, 60, 44);
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [constantView addSubview:button];
    }
    self.navigationItem.titleView = constantView;
}
- (void)segmentButtonClicked:(UIButton*)button {
    _isLocked = YES;
    NSInteger index = button.tag - 100;
    [self selectSegmentAtIndex:index];
    CGFloat offset = self.iView.contentView.contentOffset.y;
    [self.iView.contentView setContentOffset:CGPointMake(index * self.view.bounds.size.width, offset) animated:YES];
    
}
- (void)selectSegmentAtIndex:(NSInteger)index {
    
    for (UIView* view in self.navigationItem.titleView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)view;
            button.selected = (button.tag) - 100 == index;
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self->_indicatorLine.frame;
        frame.origin.x = index * 60 + 60;
        self->_indicatorLine.frame = frame;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isLocked = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
<<<<<<< HEAD
    if (_isLocked) {
        return;
    }
    CGFloat offset = self.iView.contentView.contentOffset.x;
    NSInteger currentIndex = round(offset / [UIScreen mainScreen].bounds.size.width);
=======
    if(_isLocked) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat progress = offsetX / (pageWidth);

    CGRect frame = _indicatorLine.frame;
    frame.origin.x = 60 + (progress * 60);
    _indicatorLine.frame = frame;
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat progress = offsetX / (pageWidth);
    NSInteger currentIndex = round(progress);
>>>>>>> upstream/main
    [self selectSegmentAtIndex:currentIndex];
    _isLocked = NO;

}
- (void)setupLine {
    _indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(60, 40, 60, 2)];
    _indicatorLine.backgroundColor = [UIColor greenColor];
    [self.navigationItem.titleView addSubview:_indicatorLine];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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
