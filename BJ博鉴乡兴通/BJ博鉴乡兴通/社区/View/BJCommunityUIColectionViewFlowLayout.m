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
    self.ary = [NSMutableArray array];
    sectionColHeights = [NSMutableArray array];
    [super prepareLayout];
    //NSLog(@"当前的一个高度数组%@", _itemHeight);
    
    //sectionInset是一个UIEdgeInset的类型，主要返回的是组之间的一个间隙
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / 2;//计算每个cell的一个宽度
    CGFloat currentMaxR = 0;
    CGFloat currentMaxL = 0;
    maxHeight = 0;
    self.sectionCount = self.collectionView.numberOfSections;
    int count = 0;
    NSInteger lastCount = [self.collectionView numberOfItemsInSection:0];
    //[sectionColHeights removeAllObjects];
    for (int section = 0; section < self.sectionCount; section++) {
        NSMutableArray *colHeight = [NSMutableArray arrayWithObjects:@(currentMaxL), @(currentMaxR), nil];
        [sectionColHeights addObject:colHeight];
        NSInteger sectionItemCount = [self.collectionView numberOfItemsInSection:section];
        if (section > 0) {
            lastCount = [self.collectionView numberOfItemsInSection:section - 1];
        }
        for (NSInteger i = 0; i < sectionItemCount; i++) { //遍历每一个cell
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:section];//获取对应的一个indexPath
            UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//设置一个对应的布局
            CGFloat height;//设置高度
            if (self.itemHeight) {
                height = [self.itemHeight[i + section * lastCount] floatValue];//设置高度
                //NSLog(@"这%ld个item的高度%lf", i + section * lastCount, height);
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
            //NSLog(@"当前的cell高度%lf", height);
            [self.ary addObject:attributes];
            self.itemSize = CGSizeMake(width, height);
            //NSLog(@"这里的%lditem的大小%lf, %lf", i + section * lastCount, self.itemSize.height, self.itemSize.width);
//            if ([colHeight[0] floatValue] > [colHeight[1] floatValue]) {
//                self.itemSize = CGSizeMake(width, ([colHeight[0] floatValue] - self.sectionInset.top) * 2 / self.itemCount - self.minimumLineSpacing);//计算对应的一个高度的同时取出一个平均值防止数据偏差太大，视图不美观的问题
//            } else {
//                self.itemSize = CGSizeMake(width, ([colHeight[1] floatValue] - self.sectionInset.top) * 2 / self.itemCount - self.minimumLineSpacing);
//            }
            count++;
        }
        currentMaxR =  [colHeight[1] floatValue];
        currentMaxL = [colHeight[0] floatValue];
        maxHeight = MAX(maxHeight, currentMaxR);
        maxHeight = MAX(maxHeight, currentMaxL);
        //NSLog(@"%lf", maxHeight);
    }
    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.sectionCount - 1]];
        
    footerAttributes.frame = CGRectMake(0, maxHeight, self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    footerAttributes.zIndex = 1024;  // 确保 Footer 不会被 Cell 遮挡
    [self.ary addObject:footerAttributes];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray arrayWithArray:self.ary];

    // 获取 Footer 并让其保持悬浮
    UICollectionViewLayoutAttributes *footerAttributes = nil;
    for (UICollectionViewLayoutAttributes *attrs in attributesArray) {
        if ([attrs.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            footerAttributes = attrs;
            break;
        }
    }
    if (footerAttributes) {
        CGFloat contentOffsetY = self.collectionView.contentOffset.y;
        CGRect frame = footerAttributes.frame;
        frame.origin.y = MAX(contentOffsetY + self.collectionView.bounds.size.height - frame.size.height - 30, maxHeight);
        //NSLog(@"footer的高度%lf", frame.origin.y);
        footerAttributes.frame = frame;
        footerAttributes.zIndex = 2028;  // 让 Footer 保持悬浮
    }
    return attributesArray;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInset.bottom + 30);
}
//- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    
//    return [NSArray arrayWithArray:self.ary];
//}

- (id)initWithFlowLayoutWithCount:(NSInteger)itemCount andSection:(NSInteger)sectionCount andHeightAry:(NSArray<NSNumber*>*)heightAry {
    if (self = [super init]) {
        _itemCount = itemCount;
        _sectionCount = sectionCount;
        _itemHeight = heightAry;
    }
    return self;
}
@end
