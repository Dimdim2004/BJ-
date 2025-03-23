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
#import "BJUploadSuccessModel.h"
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
- (void)loadWithCommentWithWorkId:(NSInteger)workId CommentId:(NSInteger)commentId withType:(NSInteger)type withPage:(NSInteger)pageId withPageSize:(NSInteger)pageSize WithSuccess:(commentSuccess)success failure:(error)returnError {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = [NSString stringWithFormat:@"%@/comment?work_id=%ld&comment_id=%ld&type=%ld&page_id=%ld&page_size=%ld",urlString , workId, commentId, type, pageId, pageSize];
    NSLog(@"%@", string);
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manger GET:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* stirng = [NSString stringWithFormat:@"%@/users/publishPost", urlString];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
   
    NSString* bearerString = [NSString stringWithFormat:@"Bearer %@", self.token];
    [manger.requestSerializer setValue:bearerString forHTTPHeaderField:@"Authorization"];
    [manger.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSMutableArray* dataAry = [NSMutableArray array];
    for (int i = 0; i < imageAry.count; i++) {
        @autoreleasepool {
            NSData* data = UIImageJPEGRepresentation(imageAry[i], 0.8);
            [dataAry addObject:data];
        }
    }
    NSDictionary* dicty = @{@"title":titleString, @"content":contentString, @"image_count":[NSNumber numberWithInt:imageAry.count]};
    [manger POST:stirng parameters:dicty headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < dataAry.count; i++) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterMediumStyle;
            [dateFormatter setDateFormat:@"yyyyMMdd_HHmmssSSS.jpeg"];
            NSString* fileName = [dateFormatter stringFromDate:[NSDate date]];
            [formData appendPartWithFileData:dataAry[i] name:@"images" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"%@", responseObject);
        BJUploadSuccessModel* model = [BJUploadSuccessModel yy_modelWithJSON:responseObject];
        uploadSuccess(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

- (void)loadImage:(NSInteger)pageId PageSize:(NSInteger)pageSize WithSuccess:(commitySuccess)commitySuccess failure:(error)returnError {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = [NSString stringWithFormat:@"%@/posts?page_id=%ld&page_size=%ld",urlString, pageId, pageSize];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [manger GET:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请图文成功");
        
        BJCommityModel* commityModel = [BJCommityModel yy_modelWithJSON:responseObject];
        if (commityModel.status == 1000) {
            NSLog(@"%@", responseObject);
            NSLog(@"%@", commityModel);
            commitySuccess(commityModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NetWork work error");
        returnError(error);
    }];

    
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
