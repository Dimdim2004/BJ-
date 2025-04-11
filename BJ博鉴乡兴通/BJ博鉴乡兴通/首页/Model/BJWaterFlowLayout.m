//
//  BJWaterFlowLayout.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import "BJWaterFlowLayout.h"



@implementation BJWaterFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.columnCount = 2;
        self.columnSpacing = 10;
        self.rowSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    _columnHeights = [NSMutableArray array];
    for (int i = 0; i < self.columnCount; i++) {
        [_columnHeights addObject:@(self.sectionInset.top)];
    }
    
    _attrsArray = [NSMutableArray array];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrsArray addObject:attrs];
    }
    self.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}

-(CGFloat)getHeightWithLowIndex{
    return [_columnHeights[0] doubleValue] > [_columnHeights[1] doubleValue] ? 1 : 0;
}

- (CGSize)collectionViewContentSize {
    int index = [self getHeightWithLowIndex];
    return CGSizeMake(0, [_columnHeights[index] doubleValue] + self.sectionInset.bottom + 50);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger lowIndex = [self getHeightWithLowIndex];
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemWidth = (width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    CGFloat itemHeight = [self.delegate heightForRowAtIndexPath:indexPath itemWidth:itemWidth] + 60;
    
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * lowIndex;
    CGFloat itemY = [_columnHeights[lowIndex] doubleValue] + self.rowSpacing;
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    self.columnHeights[lowIndex] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes
            layoutAttributesForSupplementaryViewOfKind:kind
                                         withIndexPath:indexPath];
        NSInteger lastItemIndex = [self.collectionView numberOfItemsInSection:0] - 1;
        UICollectionViewLayoutAttributes *lastItemAttrs = [self layoutAttributesForItemAtIndexPath:
            [NSIndexPath indexPathForItem:lastItemIndex inSection:0]];
        CGFloat footerY = CGRectGetMaxY(lastItemAttrs.frame) + self.sectionInset.bottom;
        attrs.frame = CGRectMake(0, footerY, self.footerReferenceSize.width, self.footerReferenceSize.height);
        return attrs;
    }
    return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}
@end
