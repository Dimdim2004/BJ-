//
//  BJCommunityViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//
#import "BJNetworkingManger.h"
#import "BJCommunityViewController.h"
#import "BJCommityCollectionViewCell.h"
#import "BJInvitationViewController.h"
#import "BJCommityModel.h"
#import "SDWebImage/SDWebImage.h"
#import "BJCommityDataModel.h"
#import "SubCommentsModel+DealWithComment.h"
#import "BJImageModel.h"
#import "NSString+CalculateHeight.h"
@interface BJCommunityViewController () {
    UIView* _indicatorLine;
    BOOL _isLocked;
    NSInteger _page;
    NSInteger _pageSize;
    NSMutableArray* _heightAry;
}

@end

@implementation BJCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLocked = NO;
    _page = 1;
    _pageSize = 8;
    id manger = [BJNetworkingManger sharedManger];
    self.model = [NSMutableArray array];
    [self setNavgationBar];
    [self setSegmentControl];
    [self setupLine];
    _heightAry = [NSMutableArray array];
//    self.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
//    self.iView.contentView.delegate = self;
//    for (int i = 0; i < 3; i++) {
//        for (int j = 0; j < 20; j++) {
//            [self->_heightAry addObject:[NSNumber numberWithInteger:(random()%20 + 123)]];
//        }
//    }
//    [self.iView setUIWithHeightAry:self->_heightAry];
//    for (int i = 0; i < 3; i++) {
//        self.iView.flowViewArray[i].delegate = self;
//        self.iView.flowViewArray[i].dataSource = self;
//        [self.iView.flowViewArray[i] registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//    }
//    
//    [self.view addSubview:self.iView];
    [manger loadImage:_page PageSize:_pageSize WithSuccess:^(BJCommityModel * _Nonnull commityModel) {
        self.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
        for (int i = 0; i < commityModel.data.count; i++) {
            @autoreleasepool {
                BJCommityDataModel* data = commityModel.data[i];
                CGFloat height = [data.title textHight:data.title andFont:[UIFont systemFontOfSize:14] Width:186.5] + 40;
                BJImageModel* imageModel = data.images[0];
                if (i < 3) {
                    NSLog(@"第几个imageModel%ld", imageModel.height);
                }
               // NSLog(@"%lf", height);
                if (imageModel.height != 0) {
                    //NSLog(@"%ld, %ld", imageModel.height, imageModel.width);
                    CGFloat imageHeight = ((CGFloat)imageModel.height / (CGFloat)imageModel.width) * 186.5;
                    //NSLog(@"image的%lf", imageHeight);
                    //NSLog(@"计算出的总高度%lf", (height + imageHeight));
                    [self->_heightAry addObject:[NSNumber numberWithFloat:(height + imageHeight)]];
                } else {
                    //NSLog(@"当前位置没有传来图片");
                    [self->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
                }
                
            }
        }
//        for (int i = 0; i < self->_heightAry.count; i++) {
//            NSLog(@"打印对应的计算出%lf", [self->_heightAry[i] floatValue]);
//        }
        [self.iView setUIWithHeightAry:self->_heightAry];
        self.iView.contentView.delegate = self;
        [self.model addObject:commityModel];
        for (int i = 0; i < 3; i++) {
            self.iView.flowViewArray[i].delegate = self;
            self.iView.flowViewArray[i].dataSource = self;
            [self.iView.flowViewArray[i] registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        }
        [self.view addSubview:self.iView];
    } failure:^(NSError * _Nonnull error) {
        self.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
        self.iView.contentView.delegate = self;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 20; j++) {
                [self->_heightAry addObject:[NSNumber numberWithInteger:(random()%20 + 123)]];
            }
        }
        [self.iView setUIWithHeightAry:self->_heightAry];
        for (int i = 0; i < 3; i++) {
            self.iView.flowViewArray[i].delegate = self;
            self.iView.flowViewArray[i].dataSource = self;
            [self.iView.flowViewArray[i] registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        }
        
        [self.view addSubview:self.iView];
        NSLog(@"error");
    }];
    
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


    
    CGFloat offset = self.iView.contentView.contentOffset.x;
    NSInteger currentIndex = round(offset / [UIScreen mainScreen].bounds.size.width);

    if(_isLocked) return;

    if (_isLocked) {
        return;
    }

    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat progress = offsetX / (pageWidth);

    CGRect frame = _indicatorLine.frame;
    frame.origin.x = 60 + (progress * 60);
    _indicatorLine.frame = frame;
    
    
}

- (void)setupLine {
    _indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(60, 40, 60, 2)];
    _indicatorLine.backgroundColor = [UIColor greenColor];
    [self.navigationItem.titleView addSubview:_indicatorLine];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    if (self.model.count == 0) {
        cell.backgroundColor = UIColor.whiteColor;
    } else {
        BJCommityModel* commityModel = self.model[indexPath.section];
        BJCommityDataModel* dataModel = commityModel.data[indexPath.item];
        cell.label.text = dataModel.title;
        cell.nameLabel.text = dataModel.username;
        if (dataModel.avatar.length != 0) {
            [cell.profileView sd_setImageWithURL:[NSURL URLWithString:dataModel.avatar]];
        } else {
            cell.profileView.image = [UIImage imageNamed:@"title.jpg"];
        }
        NSArray* ary = dataModel.images;
        if (ary.count != 0) {
            BJImageModel* imageModel = ary[0];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"1.png"];
        }
        cell.likeButton.selected = dataModel.isFavorite;
        [cell.likeButton setTitle:[NSString stringWithFormat:@"%ld",dataModel.favoriteCount] forState:UIControlStateNormal];
        cell.contentView.backgroundColor = UIColor.whiteColor;
    }
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.model.count != 0) {
        BJCommityModel* commityModel = self.model[section];
        return commityModel.data.count;
    } else {
        return 20;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.model.count != 0) {
        return self.model.count;
    } else {
        return 3;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BJInvitationViewController* invitationViewController = [[BJInvitationViewController alloc] init];
    invitationViewController.hidesBottomBarWhenPushed = YES;
    if (self.model.count != 0) {
        BJCommityModel* commityModel = self.model[indexPath.section];
        BJCommityDataModel* dataModel = commityModel.data[indexPath.item];
        invitationViewController.commityModel = dataModel;
        invitationViewController.workId = dataModel.postId;
        NSLog(@"%ld", dataModel.images.count);
        BJImageModel* firstImage = dataModel.images[0];
        NSLog(@"%ld", firstImage.height);
    } else {
        invitationViewController.workId = 0;
    }
    [self.navigationController pushViewController:invitationViewController animated:YES];
    
    
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
