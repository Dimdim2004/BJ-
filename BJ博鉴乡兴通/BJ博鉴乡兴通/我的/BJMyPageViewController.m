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
#import "SDWebImage/SDWebImage.h"
#import "BJNetworkingManger.h"
#import "NSString+CalculateHeight.h"
#import "BJMyPageFootReusableView.h"
@interface BJMyPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BJMyPageView* mainView;
@property (nonatomic, strong) NSMutableArray* heightAry;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray* imageAry;
@end

@implementation BJMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainView = [[BJMyPageView alloc] initWithFrame:CGRectMake(0, 97.67, 393, 769)];
    [self.view addSubview:self.mainView];
    [self regiserCollectionView];
    [self setNavgationBar];
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
    [[BJNetworkingManger sharedManger] searchUserWorksWithUserId:[BJNetworkingManger sharedManger].userId WithPage:_pageId WithPageSize:self.pageSize loadHomeSuccess:^(BJMyPageLikeModel * _Nonnull dataModel) {
        dispatch_group_enter(group);
        __strong BJMyPageViewController* strongSelf = weakSelf;
        self.iModel = dataModel;
        NSArray* postAry = dataModel.posts;
        NSArray* videosAry = dataModel.videos;
        NSMutableArray* urlAry = [NSMutableArray array];
        for (int i = 0; i < postAry.count; i++) {
            @autoreleasepool {
                BJMyPagePostModel* postModel = postAry[i];
                [urlAry addObject:postModel.coverUrl];
                CGFloat height = [postModel.title textHight:postModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5];
                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];

            }
            
        }
        for (int i = 0; i < videosAry.count; i++) {
            @autoreleasepool {
                BJMyPageViedoModel* videoModel = videosAry[i];
                [urlAry addObject:videoModel.coverUrl];
                CGFloat height = [videoModel.title textHight:videoModel.title andFont:[UIFont systemFontOfSize:17] Width:186.5];
                [strongSelf->_heightAry addObject:[NSNumber numberWithFloat:(height + 166.72)]];
            }
            
        }
        dispatch_group_leave(group);
        [self loadImageWithAry:urlAry];
    } error:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    NSInteger userId = [BJNetworkingManger sharedManger].userId;
    [[BJNetworkingManger sharedManger] loadPersonWithUserId:userId loadUserSuccess:^(BJMyPageModel * _Nonnull userModel) {
        dispatch_group_enter(group);
        NSLog(@"loadSuccess");
        dispatch_group_leave(group);
    } error:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
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
    NSLog(@"加载图片刷新瀑布流");
    NSLog(@"%d", ary.count);
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < ary.count; i++) {
        NSString* urlString = ary[i];
        dispatch_group_enter(group);
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (finished && image) {
                __strong BJMyPageViewController* strongSelf = weakSelf;
                [strongSelf.imageAry addObject:image];
                CGFloat imageHieght = image.size.height * 1.0 / image.size.width * 186.5;
                NSLog(@"imageHeight%lf", imageHieght);
                strongSelf->_heightAry[i] = @([strongSelf->_heightAry[i] floatValue] + imageHieght - 166.72);
                NSLog(@"%lf", [strongSelf->_heightAry[i] floatValue]);
                dispatch_group_leave(group);
            }
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"回调函数刷新瀑布流");
        __strong BJMyPageViewController* strongSelf = self;
        UICollectionView* collectionView = strongSelf.mainView.collectionView;
        [collectionView reloadData];
    });
}
- (void)regiserCollectionView {
    self.heightAry = [NSMutableArray array];
    [self.heightAry addObject:@(273)];
    for (int i = 0; i < 20; i++) {
        [self.heightAry addObject:@(100)];
    }
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
        cell.nameLabel.text = @"Bb带我做项目";
        cell.iconView.image = [UIImage imageNamed:@"WechatIMG17.jpg"];
        return cell;
    } else {
        BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
        
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
    return self.heightAry.count + 1;
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
