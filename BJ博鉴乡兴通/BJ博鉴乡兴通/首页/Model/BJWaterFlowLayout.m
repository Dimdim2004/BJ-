//
//  BJWaterFlowLayout.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import "BJWaterFlowLayout.h"

@implementation BJWaterFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    NSInteger columnCount = 2; // 两列布局
    CGFloat itemWidth = (self.collectionView.bounds.size.width - (columnCount - 1) * 10) / columnCount;
    
    // 初始化列高度数组
    _columnHeights = [NSMutableArray array];
    for (int i = 0; i < columnCount; i++) {
        [_columnHeights addObject:@(self.sectionInset.top)];
    }
    
    // 计算每个 item 的位置
    _attributesArray = [NSMutableArray array];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attributesArray addObject:attrs];
    }
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // 获取数据模型中的高度
//    PostModel *model = self.dataSource[indexPath.item];
//    CGFloat itemHeight = model.imageHeight + 60; // 60为标题和描述的固定高度
//    
//    // 找到最短列
//    NSInteger shortestColumn = 0;
//    CGFloat minHeight = [_columnHeights[0] floatValue];
//    for (int i = 1; i < _columnHeights.count; i++) {
//        if ([_columnHeights[i] floatValue] < minHeight) {
//            minHeight = [_columnHeights[i] floatValue];
//            shortestColumn = i;
//        }
//    }
//    
//    // 计算坐标
//    CGFloat x = self.sectionInset.left + (itemWidth + 10) * shortestColumn;
//    CGFloat y = minHeight + 10;
//    CGRect frame = CGRectMake(x, y, itemWidth, itemHeight);
//    
//    // 更新列高度
//    _columnHeights[shortestColumn] = @(CGRectGetMaxY(frame));
//    
//    // 创建布局属性
//    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attrs.frame = frame;
//    return attrs;
//}
@end
