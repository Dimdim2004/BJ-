//
//  BJForgetPasswordViewModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCheckEmailViewModel.h"
#import "AFNetworking/AFNetworking.h"
#import "BJCheckEmailModel.h"
#import "BJNetworkingManger.h"
@implementation BJCheckEmailViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[BJCheckEmailModel alloc] init];
    }
    return self;
}
- (BOOL)isValidEmail {
    NSString *email = self.user.email;
    NSString *pattern = @"^[1-9][0-9]{4,}@qq\\.com$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:email];
}

- (void)submmitWithSuccess:(checkSuccess)success failure:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:@"https://39.105.136.3:9797"];
    NSString* string = @"https://39.105.136.3:9797/validemail";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"%@", self.user.email);
    NSDictionary* dicty = @{@"email":self.user.email};
    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        BJCheckEmailModel* userModel = [BJCheckEmailModel yy_modelWithJSON:responseObject];
        NSLog(@"Success: %@", responseObject);
        
            success(userModel);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
