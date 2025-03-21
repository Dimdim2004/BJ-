//
//  BJNetworkingManger.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJNetworkingManger.h"
#import "AFNetworking/AFNetworking.h"
static id sharedManger = nil;
const NSString* urlString = @"http://3.112.71.79:43223";
@implementation BJNetworkingManger
+(instancetype) sharedManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManger = [[super allocWithZone:NULL] init];
    });
    return sharedManger;
}
- (void)loadWithViedoId:(NSInteger)viedoId CommentId:(NSInteger)commentId WithSuccess:(commentSuccess)success failure:(error)error {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = [NSString stringWithFormat:@"%@/comment?video_id=%ld&comment_id=%ld",urlString , viedoId, commentId];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"%ld, %ld", viedoId, commentId);
    [manger GET:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请评论成功");
        BJCommentsModel* commentModel = [BJCommentsModel yy_modelWithJSON:responseObject];
        NSLog(@"%@", responseObject);
        success(commentModel);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)uploadWithImage:(NSArray<NSString*>*)imageAry andTitle:(NSString*)titleString Content:(NSString*) contentString {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* stirng = [NSString stringWithFormat:@"%@", urlString];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manger.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manger.requestSerializer setValue:@"mulitpart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSDictionary* dicty = @{@"title":titleString, @"content":contentString, @"image_count":@(imageAry.count)};
    NSMutableArray* dataAry = [NSMutableArray array];
    for (int i = 0; i < imageAry.count; i++) {
        [dataAry addObject: ]
    }
    [manger POST:stirng parameters:dicty headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>]
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
@end
