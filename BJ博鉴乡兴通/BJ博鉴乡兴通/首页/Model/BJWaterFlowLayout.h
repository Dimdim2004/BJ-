//
//  BJWaterFlowLayout.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BJWaterFlowLayoutDelegate <NSObject>
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@end
@interface BJWaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<BJWaterFlowLayoutDelegate> delegate;
//总列数
@property (nonatomic, assign) NSInteger columnCount;
//列间距
@property (nonatomic, assign) NSInteger columnSpacing;
//行间距
@property (nonatomic, assign) NSInteger rowSpacing;
//section到collectionView的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//保存每一列最大y值的数组
@property (nonatomic, strong) NSMutableArray *columnHeights;
//保存每一个item的attributes的数组
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

NS_ASSUME_NONNULL_END
