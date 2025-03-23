//
//  BJScaleTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/17.
//

#import "BJScaleTableViewCell.h"
#import <Masonry.h>
#import "BJScaleFlowLayout.h"

@interface BJScaleTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    BJScaleFlowLayout *_layout;
}


@end
@implementation BJScaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.imageArray = [[NSMutableArray alloc] init];
        [self setImageArrayForName:@[@"1.png", @"2.png", @"3.png", @"4.png", @"5.png"]];
        [self setupTimer];
        CGFloat pageWidth = _layout.itemSize.width + _layout.minimumLineSpacing;
        CGFloat initialOffset = (self.imageArray.count) * pageWidth;
        [self.collectionView setContentOffset:CGPointMake(initialOffset, 0) animated:NO];
    }
    return self;
}

-(void)setImageArrayForName:(NSArray *)names {
    for (NSString *name in names) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 15;
        [self.imageArray addObject:imageView];
    }
    
}

-(void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)setupViews {
    _layout = [[BJScaleFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   

   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
   CGFloat itemWidth = screenWidth - 140;
   CGFloat itemSpacing = 40;
   
    _layout.itemSize = CGSizeMake(itemWidth, 200);
    _layout.minimumLineSpacing = 40;

    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:_layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.contentView addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = self.imageArray[indexPath.item % self.imageArray.count];
    [cell.contentView addSubview:imageView];
    imageView.frame = cell.contentView.bounds;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.imageArray.count * 3;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat padding = (collectionView.bounds.size.width - _layout.itemSize.width) / 2;
    return UIEdgeInsetsMake(0, padding, 0, padding);
}

- (void)nextPage {
    CGFloat pageWidth = _layout.itemSize.width + _layout.minimumLineSpacing;
    NSInteger currentPage = round(self.collectionView.contentOffset.x / pageWidth);
    CGFloat offsetX = (currentPage + 1) * pageWidth;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   if ([_timer isValid]) {
       [_timer invalidate];
       _timer = nil;
   }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   if (![_timer isValid]) {
       _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
       NSRunLoop *loop = [NSRunLoop currentRunLoop];
       [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
   }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _layout.itemSize.width + _layout.minimumLineSpacing;
    CGFloat maxOffsetX = pageWidth * (self.imageArray.count * 2);
    
    // 向右滚动越界时重置到中间段
    if (scrollView.contentOffset.x >= maxOffsetX) {
        [scrollView setContentOffset:CGPointMake(pageWidth * self.imageArray.count, 0) animated:NO];
    }
    // 向左滚动越界时重置到中间段
    else if (scrollView.contentOffset.x <= pageWidth * (self.imageArray.count - 1)) {
        [scrollView setContentOffset:CGPointMake(pageWidth * (self.imageArray.count * 2 - 1), 0) animated:NO];
    }
}
@end
