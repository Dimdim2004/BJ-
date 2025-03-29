//
//  BJMyPagePostModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPagePostModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* coverUrl;
@property (nonatomic, copy) NSString* viedoUrl;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* favoriteCount;
@property (nonatomic, assign) NSInteger workId;
@end

NS_ASSUME_NONNULL_END
