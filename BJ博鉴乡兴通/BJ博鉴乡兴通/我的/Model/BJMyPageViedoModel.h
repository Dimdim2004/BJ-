//
//  BJMyPageViedoModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
@class BJMyPageDealModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageViedoModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* coverUrl;
@property (nonatomic, copy) NSString* videoUrl;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL isFavourite;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, copy) NSString* avatar;
- (BJMyPageDealModel*)changeToShowModel;
@end

NS_ASSUME_NONNULL_END
