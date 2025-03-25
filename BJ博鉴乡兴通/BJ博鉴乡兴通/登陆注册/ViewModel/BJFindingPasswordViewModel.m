//
//  BJFindingPasswordViewModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/12.
//

#import "BJFindingPasswordViewModel.h"
#import "AFNetworking.h"
#import "BJFindPasswordSuccessModel.h"
#import "BJNetworkingManger.h"
@implementation BJFindingPasswordViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[BJFindPasswordSuccessModel alloc] init];
    }
    return self;
}
- (instancetype)initWithAuthTyoe:(NSInteger)authType {
    self = [super init];
    if (self) {
        self.user = [[BJFindPasswordSuccessModel alloc] init];
        self.authType = authType;
    }
    return self;
}
- (BOOL)isVailSame {
    return [self.user.password isEqualToString:self.user.rePassword];
}
- (BOOL)isVaildPassword {
    NSString *pattern = @"^(?=.*[A-Z])(?=.*[a-z])[A-Za-z0-9]{6,}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self.user.password];
    return isMatch && self.user.password.length >= 6;
}
- (void)submmitWithSuccess:(findSuccess)success failure:(error)error {
    AFHTTPSessionManager *manager = [BJNetworkingManger BJcreateAFHTTPSessionManagerWithBaseURLString:@"https://121.43.226.108:8080"];
    NSString* string = @"https://121.43.226.108:8080/reset";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary* dicty = @{@"new_password":self.user.password,@"re_password":self.user.rePassword, @"email":self.user.email};
    NSLog(@"%@,%@,%@", self.user.password, self.user.rePassword, self.user.email);
    [manager POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        BJFindPasswordSuccessModel* userModel = [BJFindPasswordSuccessModel yy_modelWithJSON:responseObject];
        NSLog(@"Success: %@", responseObject);
        if (success && userModel.status == 1000) {
            success(userModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
