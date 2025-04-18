//
//  BJNetworkingManger.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import "BJCommentsModel.h"
@class AFHTTPSessionManager;
@class BJCommityModel;
@class BJUploadSuccessModel;
@class BJUploadCommentModel;
@class BJAttentionDataModel;
@class BJMyPageLikeModel;
@class BJMyPageModel;
@class BJUploadSuccessModel,BJCountryModel,BJDynamicModel,BJLocationModel;
@class UIImage;
NS_ASSUME_NONNULL_BEGIN

@interface BJNetworkingManger : NSObject
typedef void(^commentSuccess)(BJCommentsModel* commentModel);
typedef void(^addressSuccess)(NSString* addressString);
typedef void(^countryIDSuccess)(NSString* countryIDString);
typedef void(^error)(NSError* error);
typedef void(^uploadSuccess)(BJUploadSuccessModel* uploadModel);
typedef void(^commitySuccess)(BJCommityModel* commityModel);
typedef void(^postCommentSuccess)(BJUploadCommentModel* commityModel);
typedef void(^attentionSuccess)(BJAttentionDataModel* dataModel);
typedef void(^attentionSuccess)(BJAttentionDataModel* dataModel);
typedef void(^homeLikeSuccess)(BJMyPageLikeModel* dataModel);
typedef void(^userSuccess)(BJMyPageModel* userModel);
typedef void(^countrySuccess)(BJCountryModel* countryModel);
typedef void(^dynamicSuccess)(NSArray<BJDynamicModel *>* dynamicModel);
typedef void(^locationSuccess)(NSArray<BJLocationModel *>* locationModel);

typedef void(^error)(NSError* error);
@property (nonatomic, strong) NSString* token;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSURLSessionDataTask *> *dicty;
- (void)loadPersonWithUserId:(NSInteger)userId loadUserSuccess:(userSuccess)success error:(error)error;
- (void)loadWithCommentWithWorkId:(NSInteger)viedoId CommentId:(NSInteger)commentId withType:(NSInteger)type withPage:(NSInteger)pageId withPageSize:(NSInteger)pageSize WithSuccess:(commentSuccess)success failure:(error)returnError;
- (void)loadImage:(NSInteger)pageId PageSize:(NSInteger)pageSize WithSuccess:(commitySuccess)commitySuccess failure:(error)returnError;
- (void)uploadWithImage:(NSArray<UIImage*>*)imageAry andTitle:(NSString*)titleString Content:(NSString*) contentString uploadSuccess:(uploadSuccess)uploadSuccess error:(error)error;
- (void)loadWithViedoId:(NSInteger)viedoId CommentId:(NSInteger)commentId WithSuccess:(commentSuccess)success failure:(error)error;
- (void)loadWithLatitude:(CGFloat)viedoId andLongitude:(CGFloat)commentId WithSuccess:(addressSuccess)success failure:(error)error;
+ (AFHTTPSessionManager *)BJcreateAFHTTPSessionManagerWithBaseURLString:(NSString *)urlString;
- (void)uploadWithComment:(NSString*)commentString andPraentId:(NSInteger)parentId replyId:(NSInteger)replyId  workId:(NSInteger)workId type:(NSInteger)type postCommentSuccess:(postCommentSuccess)postCommentSuccess error:(error)error;
- (void)attentionSomeone:(NSInteger)userId follow:(BOOL)follow attenationSuccess:(attentionSuccess)success error:(error)error;
- (void)likeWork:(NSInteger)workId andType:(NSInteger)type attenationSuccess:(attentionSuccess)success error:(error)error;
- (void)searchUserWorksWithUserId:(NSInteger)userId WithPage:(NSInteger)pageId WithPageSize:(NSInteger)pageSize loadHomeSuccess:(homeLikeSuccess)success error:(error)error;
- (void)deleteCommentId:(NSInteger)commentId WithWorkId:(NSInteger)workId WithType:(NSInteger)type loadSuccess:(attentionSuccess)deleteSuccess failure:(error)error;
- (void)uploadWithComment:(NSString*)commentString andPraentId:(NSInteger)parentId replyId:(NSInteger)replyId  workId:(NSInteger)workId type:(NSInteger)type uploadSuccess:(uploadSuccess)uploadSuccess error:(error)error;

- (void)loadWithCountryID:(NSInteger)countryID WithSuccess:(commitySuccess)success failure:(error)error;
- (void)findTargetCountryWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude WithSuccess:(countrySuccess)success failure:(error)error;
- (void)uploadWithParams:(NSDictionary*)params uploadSuccess:(countryIDSuccess)countryIDSuccess error:(error)error;
-(void)loadCountryInfoWithCountryID:(NSInteger)countryID WithSuccess:(countrySuccess)success failure:(error)error;
- (void)loadMainPageImage:(NSInteger)pageId PageSize:(NSInteger)pageSize WithSuccess:(dynamicSuccess)success failure:(error)returnError;
-(void)loadAllCountryIDWithSuccess:(locationSuccess)success failure:(error)error;
+(instancetype) sharedManger;
@end

NS_ASSUME_NONNULL_END
