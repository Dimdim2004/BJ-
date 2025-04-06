//
//  BJNetworkingManger.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJNetworkingManger.h"
#import <MapKit/MapKit.h>
#import "AFNetworking/AFNetworking.h"
#import "BJCommityModel.h"
#import "UIKit/UIImage.h"
#import "BJUploadCommentModel.h"
#import "BJAttentionDataModel.h"
#import "BJUploadSuccessModel.h"
#import "BJMyPageModel.h"
#import "BJMyPageLikeModel.h"
static id sharedManger = nil;
const NSString* urlString = @"https://39.105.136.3:9797";
const NSString* mapAPK = @"dhK73tBBx4BWr97HK8JnKocfz53ctjps";
@implementation BJNetworkingManger {
    NSMutableDictionary<NSIndexPath *, NSURLSessionDataTask *> *dicty;
}
+(instancetype) sharedManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManger = [[super allocWithZone:NULL] init];
    });
    return sharedManger;
}
- (void)loadWithCommentWithWorkId:(NSInteger)workId CommentId:(NSInteger)commentId withType:(NSInteger)type withPage:(NSInteger)pageId withPageSize:(NSInteger)pageSize WithSuccess:(commentSuccess)success failure:(error)returnError {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    NSString* string = [NSString stringWithFormat:@"%@/comment?work_id=%ld&comment_id=%ld&type=%ld&page=%ld&page_size=%ld",urlString , workId, commentId, type, pageId, pageSize];
    NSLog(@"%@", string);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请评论成功");
        BJCommentsModel* commentModel = [BJCommentsModel yy_modelWithJSON:responseObject];
        NSLog(@"%@", responseObject);
        NSLog(@"%@", commentModel.commentList);
        success(commentModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NewWork error");
        returnError(error);
    }];
}
- (void)uploadWithImage:(NSArray<UIImage*>*)imageAry andTitle:(NSString*)titleString Content:(NSString*) contentString uploadSuccess:(uploadSuccess)uploadSuccess error:(error)error {
    AFHTTPSessionManager *manger = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    NSString* stirng = [NSString stringWithFormat:@"%@/users/publishPost", urlString];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
   
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manger.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    //[manger.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableArray* dataAry = [NSMutableArray array];
    for (int i = 0; i < imageAry.count; i++) {
        @autoreleasepool {
            NSLog(@"这张图片的地址%p", imageAry[i]);
            
            NSData* data = UIImageJPEGRepresentation(imageAry[i], 0.8);
            if (data == nil) {
                NSLog(@"解析失败了");
            }
            NSLog(@"第 %d 张图片: 长度 = %lu", i, (unsigned long)data.length);
            [dataAry addObject:data];
        }
    }
    NSDictionary* dicty = @{@"title":titleString, @"content":contentString, @"image_count":[NSNumber numberWithInt:imageAry.count]};
    [manger POST:stirng parameters:dicty headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < dataAry.count; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
            NSString* pemName = [NSString stringWithFormat:@"images"];
            [formData appendPartWithFileData:dataAry[i] name:pemName fileName:fileName mimeType:@"image/jpeg"];
            NSLog(@"%@", fileName);
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"%@", responseObject);
        BJUploadSuccessModel* model = [BJUploadSuccessModel yy_modelWithJSON:responseObject];
        NSLog(@"%@", model.data);
        uploadSuccess(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

- (void)loadImage:(NSInteger)pageId PageSize:(NSInteger)pageSize WithSuccess:(commitySuccess)commitySuccess failure:(error)returnError {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    NSString* string = [NSString stringWithFormat:@"%@/posts?page=%ld&page_size=%ld",urlString, pageId, pageSize];
   
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (self.token) {
        NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
        [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请图文成功");
        
        BJCommityModel* commityModel = [BJCommityModel yy_modelWithJSON:responseObject];
        if (commityModel.status == 1000) {
            NSLog(@"%@", responseObject);
            //NSLog(@"%@", commityModel);
            commitySuccess(commityModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NetWork work error");
        returnError(error);
    }];

    
}

+ (AFHTTPSessionManager *)BJcreateAFHTTPSessionManagerWithBaseURLString:(NSString *)urlString{

#warning 注意：当导入工程时请在这里修改证书名字。并在工程中导入证书。如果证书类型不是cer则自行修改

    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSLog(@"%@", cerPath);
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];

    NSSet * certSet = [[NSSet alloc]initWithObjects:certData, nil];

    /** 这里创建安全策略 */

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    // 是否允许, YES为允许自签证书

    securityPolicy.allowInvalidCertificates = YES;

    // 是否验证域名

    securityPolicy.validatesDomainName = NO;

    // 设置证书

    securityPolicy.pinnedCertificates = certSet;

    //创建控制器 并做部分配置

    //创建manager时请指定一个BaseURL。

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:urlString]];

    //导入安全策略

    manager.securityPolicy = securityPolicy;

   //设置默认解析类型，get用responseSerializer，post用requestSerializer ，如果不设置对应的serializer调用时将会报错

    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // 超时响应时间设置

    manager.requestSerializer.timeoutInterval = 10;

    return manager;

}
+(NSString *)contentTypeForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;

}
- (void)loadWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude WithSuccess:(addressSuccess)success failure:(error)error {
    NSString *urlString = [NSString stringWithFormat:@"https://api.map.baidu.com/reverse_geocoding/v3/?ak=dhK73tBBx4BWr97HK8JnKocfz53ctjps&extensions_poi=1&entire_poi=1&sort_strategy=distance&output=json&coordtype=bd09ll&location=%.6f,%.6f",latitude,longitude];
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manger GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请地理编码成功");
        NSLog(@"%@", responseObject);
        NSString* addressString = [NSString stringWithFormat:@"%@", responseObject[@"result"][@"formatted_address"]];
        NSLog(@"%@",addressString);
        success(addressString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

- (void)uploadWithComment:(NSString*)commentString andPraentId:(NSInteger)parentId replyId:(NSInteger)replyId  workId:(NSInteger)workId type:(NSInteger)type postCommentSuccess:(postCommentSuccess)postCommentSuccess error:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString* string = [NSString stringWithFormat:@"%@/users/comment", urlString];
    NSDictionary* dicty = @{@"content":commentString, @"parent_id":[NSNumber numberWithInteger:parentId], @"reply_to_id":[NSNumber numberWithInteger:replyId] ,@"work_id":[NSNumber numberWithInteger:workId], @"type":[NSNumber numberWithInteger:type]};
    NSLog(@"%@", dicty);
    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        BJUploadCommentModel* commentModel = [BJUploadCommentModel yy_modelWithJSON:responseObject];
        NSLog(@"Success: %@", responseObject);
        postCommentSuccess(commentModel);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)attentionSomeone:(NSInteger)userId follow:(BOOL)follow attenationSuccess:(attentionSuccess)success error:(error)error{
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    //[manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString* string = @"";
    if (follow) {
        string = [NSString stringWithFormat:@"%@/users/follow", urlString];
    } else {
        string = [NSString stringWithFormat:@"%@/users/unfollow", urlString];
    }
    NSLog(@"%ld", userId);
    NSDictionary* dicty = @{@"follower_id":[NSNumber numberWithInteger:userId]};
    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        BJAttentionDataModel* dataModel = [BJAttentionDataModel yy_modelWithJSON:responseObject];
        NSLog(@"%@, %ld, %@", dataModel.msg, dataModel.status, dataModel.data);
        success(dataModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)likeWork:(NSInteger)workId andType:(NSInteger)type attenationSuccess:(attentionSuccess)success error:(error)error{
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString* string = [NSString stringWithFormat:@"%@/users/likeOrNot", urlString];
    NSDictionary* dicty = @{@"work_id":@(workId), @"type":@(type)};
    NSLog(@"%@", dicty);
    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        BJAttentionDataModel* dataModel = [BJAttentionDataModel yy_modelWithJSON:responseObject];
        NSLog(@"%@, %ld, %@", dataModel.msg, dataModel.status, dataModel.data);
        success(dataModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)searchUserWorksWithUserId:(NSInteger)userId WithPage:(NSInteger)pageId WithPageSize:(NSInteger)pageSize loadHomeSuccess:(homeLikeSuccess)success error:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    NSString* string = [NSString stringWithFormat:@"%@/works",urlString];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary* dicty = @{@"user_id":@(userId), @"page":@(pageId), @"page_size":@(pageSize)};
    [manager GET:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"申请个人主页成功");
        BJMyPageLikeModel* likeModel = [BJMyPageLikeModel yy_modelWithJSON:responseObject];
        //NSLog(@"%@", responseObject);
        //NSLog(@"%@", likeModel.posts);
        success(likeModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NewWork error");
    }];
}
- (void)loadPersonWithUserId:(NSInteger)userId loadUserSuccess:(userSuccess)success error:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];
    NSString* string = [NSString stringWithFormat:@"%@/home?user_id=%ld",urlString, userId];
    NSLog(@"%d", userId);
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    ;
    [manager GET:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请个人信息成功");
        BJMyPageModel* likeModel = [BJMyPageModel yy_modelWithJSON:responseObject];
        NSLog(@"%@", responseObject);
        success(likeModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NewWork error");
    }];
}
- (void)deleteCommentId:(NSInteger)commentId WithWorkId:(NSInteger)workId WithType:(NSInteger)type loadSuccess:(attentionSuccess)deleteSuccess failure:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:urlString];

    NSString *string = [NSString stringWithFormat:@"%@/users/uncomment", urlString];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 发送 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 解析 JSON
    
    NSString *bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manager.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *dicty = @{@"comment_id": @(commentId), @"work_id": @(workId), @"type": @(type)};

    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BJAttentionDataModel* deleteModel = [BJAttentionDataModel yy_modelWithJSON:responseObject];
        NSLog(@"%@", responseObject);
        deleteSuccess(deleteModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NewWork error: %@", error);
    }];
}

@end
