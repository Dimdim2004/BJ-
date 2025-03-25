//
//  BJMyPageFlowLayout.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, readwrite, strong) NSMutableArray* ary;
@property (nonatomic, readonly, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, strong) NSArray<NSNumber*>* itemHeight;
@end

NS_ASSUME_NONNULL_END
