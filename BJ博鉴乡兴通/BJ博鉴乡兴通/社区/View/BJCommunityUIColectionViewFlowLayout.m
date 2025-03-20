//
//  BJCommunityUIColectionViewFlowLayout.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/22.
//

#import "BJCommunityUIColectionViewFlowLayout.h"

@implementation BJCommunityUIColectionViewFlowLayout {
    NSMutableArray<NSMutableArray *> *sectionColHeights;
    float maxHeight;
}
- (void)prepareLayout {
    if (!self.ary) {
        self.ary = [NSMutableArray array];
    }
    sectionColHeights = [NSMutableArray array];
    [super prepareLayout];
    //sectionInset是一个UIEdgeInset的类型，主要返回的是组之间的一个间隙
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / 2;//计算每个cell的一个宽度
    CGFloat currentMaxR = 0;
    CGFloat currentMaxL = 0;
    maxHeight = 0;
    self.sectionCount = self.collectionView.numberOfSections;
    int count = 0;
    //[sectionColHeights removeAllObjects];
    for (int section = 0; section < self.sectionCount; section++) {
        NSMutableArray *colHeight = [NSMutableArray arrayWithObjects:@(currentMaxL), @(currentMaxR), nil];
        [sectionColHeights addObject:colHeight];
        NSInteger sectionItemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger i = 0; i < sectionItemCount; i++) { //遍历每一个cell
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:section];//获取对应的一个indexPath
            UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//设置一个对应的布局
            CGFloat height;//设置高度
            if (!self.itemHeight) {
                height = [self.itemHeight[i] floatValue] + 30;//设置高度
            } else {
                height = random() % 30 + 120;//设置高度
            }
            int indexCol = 0;  //标记短的列
            if ([colHeight[0] floatValue] < [colHeight[1] floatValue]) {
                colHeight[0] = @([colHeight[0] floatValue] + height + self.minimumLineSpacing);
                indexCol = 0;
            } else {
                colHeight[1] = @([colHeight[1] floatValue] + height + self.minimumLineSpacing);
                indexCol = 1;
            }
           
            attributes.frame = CGRectMake(self.sectionInset.left + (self.minimumInteritemSpacing + width) * indexCol, [colHeight[indexCol] floatValue] - height - self.minimumLineSpacing, width, height);//设置布局的一个位置
            [self.ary addObject:attributes];
            if ([colHeight[0] floatValue] > [colHeight[1] floatValue]) {
                self.itemSize = CGSizeMake(width, ([colHeight[0] floatValue] - self.sectionInset.top) * 2 / self.itemCount - self.minimumLineSpacing);//计算对应的一个高度的同时取出一个平均值防止数据偏差太大，视图不美观的问题
            } else {
                self.itemSize = CGSizeMake(width, ([colHeight[1] floatValue] - self.sectionInset.top) * 2 / self.itemCount - self.minimumLineSpacing);
            }
            count++;
        }
        currentMaxR =  [colHeight[1] floatValue];
        currentMaxL = [colHeight[0] floatValue];
        maxHeight = MAX(maxHeight, currentMaxR);
        maxHeight = MAX(maxHeight, currentMaxL);
        NSLog(@"%lf", maxHeight);
    }
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInset.bottom);
}
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [NSArray arrayWithArray:self.ary];
}
- (id)initWithFlowLayoutWithCount:(NSInteger)itemCount andSection:(NSInteger)sectionCount andHeightAry:(NSArray<NSNumber*>*)heightAry {
    if (self = [super init]) {
        _itemCount = itemCount;
        _sectionCount = sectionCount;
        _itemHeight = heightAry;
    }
    return self;
}
@end
