//
//  CommentsModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/24.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
#import "BJSubCommentsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJCommentsModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, strong) NSMutableArray* commentList;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pageId;
@end



NS_ASSUME_NONNULL_END
