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
#import "BJCommityFootReusableView.h"
#import "BJCommityFootReusableView.h"
#import "BJCommunityUIColectionViewFlowLayout.h"
@interface BJCommunityViewController () {
    UIView* _indicatorLine;
    BOOL _isLocked;
    NSInteger _page;
    NSInteger _pageSize;
    NSMutableArray* _heightAry;
    NSMutableArray* _imageAry;
    NSMutableArray* _imageURLAry;
    BOOL _isLoading;
    NSMutableArray* _calcutaeAry;
    BOOL _loadMore;
}

@end

@implementation BJCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_imageAry = [NSMutableArray array];
    _isLocked = NO;
    _page = 1;
    _loadMore = YES;
    _isLoading = NO;
    _pageSize = 4;
    [self setNavgationBar];
    id manger = [BJNetworkingManger sharedManger];
    self.model = [NSMutableArray array];
    _heightAry = [NSMutableArray array];
    __weak BJCommunityViewController* weakSelf = self;
    self->_imageURLAry = [NSMutableArray array];
    self->_calcutaeAry = [NSMutableArray array];
    [manger loadImage:_page PageSize:_pageSize WithSuccess:^(BJCommityModel * _Nonnull commityModel) {
        weakSelf.iView = [[BJMainCommunityView alloc] initWithFrame:weakSelf.view.bounds];
        __strong BJCommunityViewController* strongSelf = weakSelf;
        for (int i = 0; i < commityModel.data.count; i++) {
            @autoreleasepool {
                BJCommityDataModel* data = commityModel.data[i];
                CGFloat height = [data.title textHight:data.title andFont:[UIFont systemFontOfSize:14] Width:186.5] + 55;
                if (data.images.count != 0) {
                    BJImageModel* imageModel = data.images[0];
                    [strongSelf->_imageURLAry addObject:imageModel.url];
                } else {
                    NSMutableArray* ary = [NSMutableArray arrayWithArray:commityModel.data];
                    [ary removeObject:data];
                    commityModel.data = [NSArray arrayWithArray:ary];
                }
                [strongSelf->_calcutaeAry addObject:[NSNumber numberWithBool:NO]];
                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height)]];
            }
        }
        [strongSelf.model addObject:commityModel];
        [strongSelf loadImageWithAry:strongSelf->_imageURLAry];
        [strongSelf.iView setUIWithHeightAry:strongSelf->_heightAry andSectionCount:strongSelf->_page itemCount:strongSelf->_heightAry.count];
        strongSelf.iView.mainView.delegate = self;
        strongSelf.iView.mainView.prefetchDataSource = self;
        strongSelf.iView.mainView.dataSource = self;
        [strongSelf.iView.mainView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [strongSelf.iView.mainView registerClass:[BJCommityFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuseFooter"];
        
        [self.view addSubview:self.iView];
    } failure:^(NSError * _Nonnull error) {
        __strong BJCommunityViewController* strongSelf = weakSelf;
        strongSelf.iView = [[BJMainCommunityView alloc] initWithFrame:self.view.bounds];
        strongSelf.iView.contentView.delegate = self;
        
            for (int j = 0; j < 20; j++) {
                [strongSelf->_heightAry addObject:[NSNumber numberWithInteger:(random()%20 + 123)]];
            }
        
        [strongSelf.iView setUIWithHeightAry:strongSelf->_heightAry andSectionCount:strongSelf->_page itemCount:strongSelf->_pageSize];
        strongSelf.iView.mainView.delegate = self;
        strongSelf.iView.mainView.dataSource = self;
        [strongSelf.iView.mainView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        
        [strongSelf.view addSubview:self.iView];
        NSLog(@"error");
    }];
}

- (void)loadMore {
    if (_loadMore == NO) {
        return;
    }
    if (self->_isLoading) {
        return;
    }
    self->_isLoading = YES;
    __weak id weakSelf = self;
    [[BJNetworkingManger sharedManger] loadImage:(_page) PageSize:_pageSize WithSuccess:^(BJCommityModel * _Nonnull commityModel) {
        __strong BJCommunityViewController* strongSelf = weakSelf;
        NSLog(@"当前拉去数组的一个值%ld", commityModel.data.count);
        [self.model addObject:commityModel];
        if (commityModel.data.count == 0) {
            strongSelf->_loadMore = NO;
        }
        for (int i = 0; i < commityModel.data.count; i++) {
            
            @autoreleasepool {
                BJCommityDataModel* data = commityModel.data[i];
                CGFloat height = [data.title textHight:data.title andFont:[UIFont systemFontOfSize:14] Width:186.5] + 55;
                BJImageModel* imageModel = data.images[0];
                [strongSelf->_imageURLAry addObject:imageModel.url];
                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height)]];
                [strongSelf->_calcutaeAry addObject:[NSNumber numberWithBool:NO]];
            }
        }
        [strongSelf loadImageWithAry:strongSelf->_imageURLAry];
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"load error");
    }];
}
- (void)loadImageWithAry:(NSArray*)ary {
    __weak id weakSelf = self;
    NSLog(@"加载图片刷新瀑布流");
    NSLog(@"当前图片个数%d", ary.count);
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < ary.count; i++) {
        if ([self->_calcutaeAry[i] boolValue]) {
            NSLog(@"以前计算过就直接退出");
            continue;
        }
        NSString* urlString = ary[i];
        dispatch_group_enter(group);
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (finished && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong BJCommunityViewController* strongSelf = weakSelf;
                    [strongSelf->_imageAry addObject:image];
                    CGFloat imageHieght = image.size.height * 1.0 / image.size.width * 186.5;
                    NSLog(@"imageHeight%lf", imageHieght);
                    strongSelf->_heightAry[i] = @([strongSelf->_heightAry[i] floatValue] + imageHieght);
                    NSLog(@"%lf", [strongSelf->_heightAry[i] floatValue]);
                    strongSelf->_calcutaeAry[i] = [NSNumber numberWithBool:YES];
                   
                    
                    dispatch_group_leave(group);
                });
            }
            
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        __strong BJCommunityViewController* strongSelf = self;
        UICollectionView* collectionView = strongSelf.iView.mainView;
        BJCommunityUIColectionViewFlowLayout* flowLayout = (BJCommunityUIColectionViewFlowLayout*)collectionView.collectionViewLayout;
        [UIView setAnimationsEnabled:NO];
        flowLayout.itemHeight = [strongSelf->_heightAry copy];
        [strongSelf.iView.mainView performBatchUpdates:^{
            NSLog(@"社区回调函数刷新瀑布流");
            NSLog(@"%ld", strongSelf->_page - 1);
            if (strongSelf->_page == 1) {
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:(strongSelf->_page - 1)]];
                strongSelf->_page++;
                
            } else {
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:(strongSelf.model.count - 1)]];
                strongSelf->_page++;
            }
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
        strongSelf->_isLoading = NO;
        BJCommityFootReusableView* footView = [self visibleFooter];
        [footView startLoading:self->_isLoading];
        if (strongSelf->_loadMore == NO) {
            [footView endLoading];
        }
    });
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
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo.png"]]];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
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
    if (scrollView.tag == 101) {
        CGFloat y = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat height = scrollView.bounds.size.height;
        if (y + height >= contentHeight - 10) {
            BJCommityFootReusableView* footView = [self visibleFooter];
            [footView startLoading:self->_isLoading];
            [self loadMore];
        }
    }
    
    
    
}

- (void)setupLine {
    _indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(60, 40, 60, 2)];
    _indicatorLine.backgroundColor = [UIColor greenColor];
    [self.navigationItem.titleView addSubview:_indicatorLine];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 3;
    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
        if (self->_imageAry.count == self->_heightAry.count) {
            BJImageModel* imageModel = ary[0];
            cell.imageView.image = self->_imageAry[indexPath.item + indexPath.section * _pageSize];
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
        NSLog(@"%当前section的个数%ld", commityModel.data.count);
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
        NSLog(@"%ld", dataModel.postId);
        BJImageModel* firstImage = dataModel.images[0];
        NSLog(@"当前点开这个人的主页的时候有没有被关注%ld", dataModel.isFollowing);
    } else {
        invitationViewController.workId = 0;
    }
    invitationViewController.delegate = self;
    [self.navigationController pushViewController:invitationViewController animated:YES];
}
#pragma mark - UITableViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    __block BOOL needFetch = NO;
    __block NSInteger count = 0;
    __block NSInteger currentIdx = 0;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (count + obj.item > self.model.count * 5) {
            needFetch = YES;
            *stop = YES;
            currentIdx = idx;
        } else {
            count += obj.item;
        }
    }];
    if (needFetch) {
        [[BJNetworkingManger sharedManger] loadImage:currentIdx + 1 PageSize:5 WithSuccess:^(BJCommityModel * _Nonnull commityModel) {
            [self.model addObject:commityModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadData];
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error");
        }];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section != self.model.count - 1) {
        return CGSizeZero;
    }
    return CGSizeMake(393, 40);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        NSLog(@"✅ 进入 Footer 分支");
        BJCommityFootReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"reuseFooter"
                                                                                  forIndexPath:indexPath];
        
        return footer;
    }
    return nil;
}
- (BJCommityFootReusableView *)visibleFooter {
    NSArray<UICollectionReusableView*> *footers = [self.iView.mainView visibleSupplementaryViewsOfKind:UICollectionElementKindSectionFooter];
    return footers.count > 0 ? (BJCommityFootReusableView *)footers.firstObject : nil;
}

-(void)updateFavourite:(NSInteger)isFavourite andCommentCount:(NSInteger)commentCount withWorkId:(NSInteger)workId {
    BJCommityModel* iModel;
    BJCommityDataModel* dataModel;
    for (int i = 0; i < self.model.count; i++) {
        iModel = self.model[i];
        for (int j = 0; j < iModel.data.count; j++) {
            dataModel = iModel.data[j];
            if (dataModel.postId == workId) {
                dataModel.isFavorite = isFavourite;
                dataModel.favoriteCount = dataModel.favoriteCount - (dataModel.isFavorite ? -1 : 1);
                dataModel.commentCount = commentCount;
                NSMutableArray* ary = [iModel.data mutableCopy];
                [ary replaceObjectAtIndex:j withObject:dataModel];
                iModel.data = [ary copy];
                [self.model replaceObjectAtIndex:i withObject:iModel];
                [self.iView.mainView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:j inSection:i]]];
                return;
            }
        }
        
    }
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
