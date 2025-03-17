//
//  BJForgetPasswordViewModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCheckEmailViewModel.h"
#import "AFNetworking/AFNetworking.h"
#import "BJCheckEmailModel.h"
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
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = @"http://3.112.71.79:43223/validemail";
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"%@", self.user.email);
    NSDictionary* dicty = @{@"email":self.user.email};
    [manger POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        BJCheckEmailModel* userModel = [BJCheckEmailModel yy_modelWithJSON:responseObject];
        NSLog(@"Success: %@", responseObject);
        if (userModel.status == 1000) {
            success(userModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
