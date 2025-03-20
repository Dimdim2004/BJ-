//
//  BJCommunityUIColectionViewFlowLayout.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJCommunityUIColectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, readwrite, strong) NSMutableArray* ary;

@property (nonatomic, readonly, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, strong) NSArray<NSNumber*>* itemHeight;
- (id)initWithFlowLayoutWithCount:(NSInteger)itemCount andSection:(NSInteger)sectionCount andHeightAry:(NSArray<NSNumber*>*)heightAry;
@end

NS_ASSUME_NONNULL_END
