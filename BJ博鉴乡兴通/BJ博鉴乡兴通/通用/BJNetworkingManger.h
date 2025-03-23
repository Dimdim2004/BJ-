//
//  BJNetworkingManger.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import "BJCommentsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJNetworkingManger : NSObject
typedef void(^commentSuccess)(BJCommentsModel* commentModel);
typedef void(^addressSuccess)(NSString* addressString);
typedef void(^error)(NSError* error);
@property (nonatomic, strong) NSString* token;
- (void)loadWithViedoId:(NSInteger)viedoId CommentId:(NSInteger)commentId WithSuccess:(commentSuccess)success failure:(error)error;
- (void)loadWithLatitude:(CGFloat)viedoId andLongitude:(CGFloat)commentId WithSuccess:(addressSuccess)success failure:(error)error;

+(instancetype) sharedManger;
@end

NS_ASSUME_NONNULL_END
