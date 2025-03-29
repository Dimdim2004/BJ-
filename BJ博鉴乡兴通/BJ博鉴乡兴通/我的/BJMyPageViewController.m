//
//  BJMyPageViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJMyPageViewController.h"
#import "BJCommityCollectionViewCell.h"
#import "BJMyPageHeaderCollectionViewCell.h"
#import "BJMyPageView.h"
#import "BJMyPageLikeModel.h"
#import "BJMyPageViedoModel.h"
#import "BJMyPagePostModel.h"
#import "BJMyPageModel.h"
#import "SDWebImage/SDWebImage.h"
#import "BJNetworkingManger.h"
#import "NSString+CalculateHeight.h"
#import "BJMyPageFootReusableView.h"
#import "BJMyPageDealModel.h"
@interface BJMyPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BJMyPageView* mainView;
@property (nonatomic, strong) NSMutableArray* heightAry;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray* imageAry;
@property (nonatomic, strong) NSMutableArray* calucateAry;
@property (nonatomic, strong) NSMutableArray* imageUrlAry;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation BJMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainView = [[BJMyPageView alloc] initWithFrame:CGRectMake(0, 97.67, 393, 769)];
    [self.view addSubview:self.mainView];
    self.imageAry = [NSMutableArray array];
    self.heightAry = [NSMutableArray array];
    self.calucateAry = [NSMutableArray array];
    self.imageUrlAry = [NSMutableArray array];
    self.iModel = [NSMutableArray array];
    [self regiserCollectionView];
    [self setNavgationBar];
    self.pageId = 1;
    self.pageSize = 3;
    
    __weak id weakSelf = self;
    
    
    [self loadAllData];
    
//    [[BJNetworkingManger sharedManger] searchUserWorksWithUserId:[BJNetworkingManger sharedManger].userId WithPage:_pageId WithPageSize:self.pageSize loadHomeSuccess:^(BJMyPageLikeModel * _Nonnull dataModel) {
//        __strong BJMyPageViewController* strongSelf = weakSelf;
//        self.iModel = dataModel;
//        NSArray* postAry = dataModel.posts;
//        NSArray* videosAry = dataModel.videos;
//        NSMutableArray* urlAry = [NSMutableArray array];
//        for (int i = 0; i < postAry.count; i++) {
//            @autoreleasepool {
//                BJMyPagePostModel* postModel = postAry[i];
//                [urlAry addObject:postModel.coverUrl];
//                CGFloat height = [postModel.title textHight:postModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5];
//                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
//
//            }
//            
//        }
//        for (int i = 0; i < videosAry.count; i++) {
//            @autoreleasepool {
//                BJMyPageViedoModel* videoModel = videosAry[i];
//                [urlAry addObject:videoModel.coverUrl];
//                CGFloat height = [videoModel.title textHight:videoModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5];
//                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
//            }
//            
//        }
//        [self loadImageWithAry:urlAry];
//    } error:^(NSError * _Nonnull error) {
//        NSLog(@"error");
//    }];
    // Do any additional setup after loading the view.
}
- (void)loadAllData {
    dispatch_group_t group = dispatch_group_create();
    __weak id weakSelf = self;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[BJNetworkingManger sharedManger] searchUserWorksWithUserId:[BJNetworkingManger sharedManger].userId WithPage:_pageId WithPageSize:self.pageSize loadHomeSuccess:^(BJMyPageLikeModel * _Nonnull dataModel) {
            
            __strong BJMyPageViewController* strongSelf = weakSelf;
            
            NSArray* postAry = dataModel.posts;
            NSArray* videosAry = dataModel.videos;
            int j = 0;
            NSLog(@"%ld %ld", postAry.count, videosAry.count);
            for (int i = 0; i < postAry.count;) {
                @autoreleasepool {
                    if (i % 3 == 0 && i != 0 && j < videosAry.count) {
                    
                            BJMyPageViedoModel* videoModel = videosAry[j];
                            [self.iModel addObject:[videoModel changeToShowModel]];
                            [strongSelf->_imageUrlAry addObject:videoModel.coverUrl];
                            CGFloat height = [videoModel.title textHight:videoModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5] + 55;
                            [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
                            [strongSelf->_calucateAry addObject:[NSNumber numberWithBool:NO]];
                            j++;
                        
                    } else {
                        BJMyPagePostModel* postModel = postAry[i];
                        [self.iModel addObject:[postModel changeToShowModel]];
                        [strongSelf->_imageUrlAry addObject:postModel.title];
                        CGFloat height = [postModel.title textHight:postModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5] + 55;
                        [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
                        [strongSelf->_calucateAry addObject:[NSNumber numberWithBool:NO]];
                        i++;
                    }
                }
            }
            
            [self loadImageWithAry:strongSelf->_imageUrlAry];
        } error:^(NSError * _Nonnull error) {
            NSLog(@"error");
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger userId = [BJNetworkingManger sharedManger].userId;
        [[BJNetworkingManger sharedManger] loadPersonWithUserId:userId loadUserSuccess:^(BJMyPageModel * _Nonnull userModel) {
            
            [BJNetworkingManger sharedManger].username = userModel.username;
            [BJNetworkingManger sharedManger].avatar = userModel.avatar;
            NSLog(@"loadSuccess");
            
        } error:^(NSError * _Nonnull error) {
            NSLog(@"error");
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.mainView.collectionView reloadData];
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
    self.navigationItem.leftBarButtonItem = leftButton;
}
- (void)loadImageWithAry:(NSArray*)ary {
    __weak id weakSelf = self;
    NSLog(@"个人主页加载图片刷新瀑布流");
    NSLog(@"个人主页当前图片个数%d", ary.count);
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < ary.count; i++) {
        if ([self->_calucateAry[i] boolValue]) {
            NSLog(@"个人主页以前计算过就直接退出");
            continue;
        }
        NSString* urlString = ary[i];
        dispatch_group_enter(group);
        
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (finished && image) {
                    __strong BJMyPageViewController* strongSelf = weakSelf;
                    [strongSelf->_imageAry addObject:image];
                    CGFloat imageHieght = image.size.height * 1.0 / image.size.width * 186.5;
                    NSLog(@"个人主页imageHeight%lf", imageHieght);
                    strongSelf->_heightAry[i] = @([strongSelf->_heightAry[i] floatValue] + imageHieght);
                    NSLog(@"个人主页高度为%lf", [strongSelf->_heightAry[i] floatValue]);
                    strongSelf->_calucateAry[i] = [NSNumber numberWithBool:YES];
            }
            dispatch_group_leave(group);
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"个人主页回调函数刷新瀑布流");
        
        __strong BJMyPageViewController* strongSelf = self;
        UICollectionView* collectionView = strongSelf.mainView.collectionView;
        [collectionView reloadData];
        strongSelf.isLoading = NO;
    });
}
- (void)regiserCollectionView {
    self.heightAry = [NSMutableArray array];
    [self.heightAry addObject:@(273)];
    [self.calucateAry addObject:[NSNumber numberWithBool:YES]];
    
    [self.mainView setUI:self.heightAry andSectionCount:self.pageId itemCount:self.heightAry.count];
    self.mainView.backgroundColor = UIColor.whiteColor;
    self.mainView.collectionView.delegate = self;
    self.mainView.collectionView.dataSource = self;
    [self.mainView.collectionView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.mainView.collectionView registerClass:[BJMyPageHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"header"];
    [self.mainView.collectionView registerClass:[BJMyPageFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuseFooter"];
   
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"尾视图加载");
        return CGSizeMake(collectionView.bounds.size.width, 100);
    } else {
        return CGSizeZero;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BJMyPageHeaderCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"header" forIndexPath: indexPath];
        if ([BJNetworkingManger sharedManger].username.length == 0) {
            cell.nameLabel.text = @"Bb带我做项目";
        } else {
            cell.nameLabel.text = [BJNetworkingManger sharedManger].username;
        }
        if ([BJNetworkingManger sharedManger].avatar.length == 0) {
            cell.iconView.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
        } else {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[BJNetworkingManger sharedManger].avatar]];
        }
        
        return cell;
    } else {
        BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
        
        if (self.iModel.count != 0) {
            BJMyPageDealModel* dealModel = self.iModel[indexPath.item];
            if (self.imageAry.count + 1 == self.heightAry.count) {
                cell.imageView.image = self.imageAry[indexPath.item];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"1.png"];
            }
            cell.label.text = dealModel.title;
            [cell.profileView sd_setImageWithURL:[NSURL URLWithString:[BJNetworkingManger sharedManger].avatar]];
        } else {
            
            
        }
        
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 0) {
        NSLog(@"✅ 进入 Footer 分支");
        BJMyPageFootReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"reuseFooter"
                                                                                  forIndexPath:indexPath];
        footer.titleLabel.text = @"我的喜欢";
        footer.titleLabel.textColor = [UIColor blackColor];
        return footer;
    }
    return nil;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.heightAry.count - 1;
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
