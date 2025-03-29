//
//  BJMyPageDealModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MyPageVideo,
    MyPagePosts,
} currentType;
@interface BJMyPageDealModel : NSObject
@property (nonatomic, copy) NSArray<NSString*>* imagesURLAry;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL isFavourte;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, assign) NSInteger workId;
@property (nonatomic, assign) NSInteger commentCount;
@end

NS_ASSUME_NONNULL_END
