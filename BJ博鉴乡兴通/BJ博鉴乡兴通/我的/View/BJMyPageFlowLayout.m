//
//  BJMyPageFlowLayout.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/25.
//

#import "BJMyPageFlowLayout.h"

@implementation BJMyPageFlowLayout {
    NSMutableArray<NSMutableArray *> *sectionColHeights;
    float maxHeight;
    double originalHeight;
}
- (void)prepareLayout {
    if (!self.ary) {
        self.ary = [NSMutableArray array];
    }
    originalHeight = 293;
    sectionColHeights = [NSMutableArray array];
    [super prepareLayout];
    UICollectionViewLayoutAttributes * headView = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    headView.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, 293);
    [self.ary addObject:headView];
    //sectionInset是一个UIEdgeInset的类型，主要返回的是组之间的一个间隙
    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    headerAttributes.frame = CGRectMake(0, 293, self.headerReferenceSize.width, self.headerReferenceSize.height);//设置头部视图布局的一个位置
    headerAttributes.zIndex = 1000;
    [self.ary addObject:headerAttributes];
    NSLog(@"%lf", headerAttributes.frame.size.height);
    
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / 2;//计算每个cell的一个宽度
    CGFloat currentMaxR = [self.itemHeight[0] floatValue];
    CGFloat currentMaxL = [self.itemHeight[0] floatValue];
    maxHeight = currentMaxL;
    self.sectionCount = self.collectionView.numberOfSections;
    NSInteger lastCount = [self.collectionView numberOfItemsInSection:0];
    int count = 0;
    //[sectionColHeights removeAllObjects];
    for (int section = 1; section < self.sectionCount; section++) {
        NSMutableArray *colHeight = [NSMutableArray arrayWithObjects:@(currentMaxL), @(currentMaxR), nil];
        [sectionColHeights addObject:colHeight];
        NSInteger sectionItemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger i = 0; i < sectionItemCount; i++) { //遍历每一个cell
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:section];//获取对应的一个indexPath
            UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//设置一个对应的布局
            CGFloat height;//设置高度
            if (section > 0) {
                lastCount = [self.collectionView numberOfItemsInSection:section - 1];
            }
            if (self.itemHeight.count > 1) {
                height = [self.itemHeight[i + section * lastCount] floatValue];//设置高度
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
            count++;
        }
        currentMaxR =  [colHeight[1] floatValue];
        currentMaxL = [colHeight[0] floatValue];
        maxHeight = MAX(maxHeight, currentMaxR);
        maxHeight = MAX(maxHeight, currentMaxL);
    }
    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.sectionCount - 1]];
        
    footerAttributes.frame = CGRectMake(0, maxHeight, self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    footerAttributes.zIndex = 1024;  // 确保 Footer 不会被 Cell 遮挡
    [self.ary addObject:footerAttributes];
}
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInset.bottom + 30);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray arrayWithArray:self.ary];
    UICollectionViewLayoutAttributes *footerAttributes = nil;
    UICollectionViewLayoutAttributes *headerAttributes = nil;
    for (UICollectionViewLayoutAttributes *attrs in attributesArray) {
        if ([attrs.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            footerAttributes = attrs;
            break;
        }
    }
    for (UICollectionViewLayoutAttributes *attrs in attributesArray) {
        if ([attrs.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            headerAttributes = attrs;
            break;
        }
    }
   
    if (footerAttributes) {
        CGFloat contentOffsetY = self.collectionView.contentOffset.y;
        CGRect frame = footerAttributes.frame;
        frame.origin.y = MAX(contentOffsetY + self.collectionView.bounds.size.height - frame.size.height - 30, maxHeight);
        NSLog(@"footer的高度%lf", frame.origin.y);
        footerAttributes.frame = frame;
        footerAttributes.zIndex = 2028;  // 让 Footer 保持悬浮
    }
    if (headerAttributes) {
        CGRect rect = headerAttributes.frame;
        if (self.collectionView.contentOffset.y > originalHeight) { //设置header高度
            rect.origin.y = self.collectionView.contentOffset.y;
            headerAttributes.frame = rect;
            //NSLog(@"header的一个位置%lf", headerAttributes.frame.origin.y);
        } else {
            rect.origin.y = originalHeight;
            headerAttributes.frame = rect;
            //NSLog(@"header的一个位置%lf", headerAttributes.frame.origin.y);
        }
        headerAttributes.zIndex = 2000;
    }
    return attributesArray;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
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
