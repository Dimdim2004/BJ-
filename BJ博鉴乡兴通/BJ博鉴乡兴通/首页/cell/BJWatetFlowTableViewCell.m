//
//  BJWatetFlowTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/4.
//

#import "BJWatetFlowTableViewCell.h"
#import "BJWaterFlowLayout.h"
#import "BJNetworkingManger.h"
#import "BJCommityDataModel.h"
#import "BJCommityModel.h"
#import "BJCommityCollectionViewCell.h"
#import <SDWebImage.h>
#import "BJImageModel.h"
#import "NSString+CalculateHeight.h"
#import "BJMyHometownViewController.h"

@interface BJWatetFlowTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,BJWaterFlowLayoutDelegate>
@property (strong, nonatomic) NSMutableArray<BJCommityDataModel *> *commityArray;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)BOOL isLoad;
@property (nonatomic, assign)BOOL hasLoadMore;
@property (nonatomic, assign) CGFloat maxOffsetY;


@end


@implementation BJWatetFlowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.page = 1;
        self.isLoad = NO;
        self.hasLoadMore = YES;
        self.commityArray = [NSMutableArray array];
        [self setupViews];
        [self setupData];
    }
    return self;
}
-(void)setupViews {
    BJWaterFlowLayout *waterFlowLayout = [[BJWaterFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    waterFlowLayout.footerReferenceSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);

    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:waterFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"FooterView"];
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    
    
}

-(void)setupData {
    [[BJNetworkingManger sharedManger] loadImage:self.page PageSize:5 WithSuccess:^(BJCommityModel * _Nonnull commityModel) {
        if (commityModel.data.count > 0) {
            self.page++;
            [self.commityArray addObjectsFromArray:commityModel.data];
            self.isLoad = NO;
            [self.collectionView reloadData];
        } else {
            self.hasLoadMore = NO;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    BJCommityDataModel *model = self.commityArray[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    cell.label.text = model.title;
    cell.nameLabel.text = model.username;
    [cell.likeButton setSelected:model.isFavorite];
    [cell.profileView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    BJImageModel *imageModel = model.images.firstObject;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageModel.url] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        model.imageSize = image.size;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            [collectionView.collectionViewLayout invalidateLayout];
        });
    }];
    return cell;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    BJCommityDataModel *model = self.commityArray[indexPath.item];
    if (CGSizeEqualToSize(model.imageSize, CGSizeZero)) {
        return 100;
    }
    CGFloat textHeight = [model.title textHight:model.title andFont:[UIFont systemFontOfSize:14] Width:itemWidth];
    return (itemWidth * model.imageSize.height) / model.imageSize.width + textHeight;

}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.commityArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.scrollDelegate scrollViewDidScroll:scrollView];
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight = scrollView.frame.size.height;
        
    if (contentOffsetY > contentHeight - frameHeight - 150) {
        [self loadMoreData];
    }
}

- (void)loadMoreData {
    if (!self.hasLoadMore) return;
    if (!self.isLoad) {
        self.isLoad = YES;
        [self setupData];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.text = @"没有更多内容了";
        label.textAlignment = NSTextAlignmentCenter;
        [footer addSubview:label];
        footer.backgroundColor = [UIColor lightGrayColor];
        return footer;
    }
    return nil;
}
@end
