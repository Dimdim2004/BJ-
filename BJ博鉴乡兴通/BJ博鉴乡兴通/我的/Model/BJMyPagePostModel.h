//
//  BJMyPagePostModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
@class BJMyPageDealModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPagePostModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, copy) NSArray* images;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, copy) NSString* timeString;
- (BJMyPageDealModel*)changeToShowModel;
@end

NS_ASSUME_NONNULL_END
