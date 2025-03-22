//
//  SubCommentsModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/24.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJSubCommentsModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* advator;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* timeString;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger replyId;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) BOOL isLike;

@end

NS_ASSUME_NONNULL_END
