//
//  BJNetworkingManger.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJNetworkingManger.h"
#import <MapKit/MapKit.h>
#import "AFNetworking/AFNetworking.h"
static id sharedManger = nil;
const NSString* urlString = @"http://3.112.71.79:43223";
const NSString* mapAPK = @"dhK73tBBx4BWr97HK8JnKocfz53ctjps";
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
@end
