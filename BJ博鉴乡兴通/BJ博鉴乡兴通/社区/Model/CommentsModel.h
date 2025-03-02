//
//  CommentsModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/24.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentsModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* comments;

@property (nonatomic, assign) BOOL isExpand;
@end

NS_ASSUME_NONNULL_END
