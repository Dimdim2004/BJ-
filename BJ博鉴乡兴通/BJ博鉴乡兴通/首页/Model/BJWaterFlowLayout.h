//
//  BJWaterFlowLayout.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJWaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@end

NS_ASSUME_NONNULL_END
