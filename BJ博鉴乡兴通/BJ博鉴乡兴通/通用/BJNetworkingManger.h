//
//  BJNetworkingManger.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import "BJCommentsModel.h"
@class BJCommityModel;
@class BJUploadSuccessModel;
@class UIImage;
NS_ASSUME_NONNULL_BEGIN

@interface BJNetworkingManger : NSObject
typedef void(^commentSuccess)(BJCommentsModel* commentModel);
typedef void(^addressSuccess)(NSString* addressString);
typedef void(^error)(NSError* error);
typedef void(^uploadSuccess)(BJUploadSuccessModel* uploadModel);
typedef void(^commitySuccess)(BJCommityModel* commityModel);
typedef void(^error)(NSError* error);
@property (nonatomic, strong) NSString* token;
- (void)loadWithCommentWithWorkId:(NSInteger)viedoId CommentId:(NSInteger)commentId withType:(NSInteger)type withPage:(NSInteger)pageId withPageSize:(NSInteger)pageSize WithSuccess:(commentSuccess)success failure:(error)returnError;
- (void)loadImage:(NSInteger)pageId PageSize:(NSInteger)pageSize WithSuccess:(commitySuccess)commitySuccess failure:(error)returnError;
- (void)uploadWithImage:(NSArray<UIImage*>*)imageAry andTitle:(NSString*)titleString Content:(NSString*) contentString uploadSuccess:(uploadSuccess)uploadSuccess error:(error)error;
- (void)loadWithViedoId:(NSInteger)viedoId CommentId:(NSInteger)commentId WithSuccess:(commentSuccess)success failure:(error)error;
- (void)loadWithLatitude:(CGFloat)viedoId andLongitude:(CGFloat)commentId WithSuccess:(addressSuccess)success failure:(error)error;

+(instancetype) sharedManger;
@end

NS_ASSUME_NONNULL_END
