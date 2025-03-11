//
//  BJRegisterModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import "BJRegisterViewModel.h"
#import "BJUserRegisterModel.h"
#import "BJCodeSuccessModel.h"
#import "BJCodeModel.h"
#import "AFNetworking/AFNetworking.h"
#import "BJRegisterSuccessModel.h"
@implementation BJRegisterViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.registerUser = [[BJUserRegisterModel alloc] init];
    }
    return self;
}
- (BOOL)isValidEmail {
    NSString *email = self.registerUser.email;
    NSString *pattern = @"^[1-9][0-9]{4,}@qq\\.com$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:email];
}
- (BOOL) isValidPassword {
    NSString *pattern = @"^(?=.*[A-Z])(?=.*[a-z])[A-Za-z0-9]{6,}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self.registerUser.password];
    return isMatch && self.registerUser.password.length >= 6;
}
- (BOOL)isValidRegister {
    return self.isValidEmail && self.isValidPassword && [self.comfirmPassword isEqualToString:self.registerUser.password];
}

- (void)sendCodeWithSuccess:(success)success failure:(error)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://3.112.71.79:43223/code";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *params = @{@"email": self.registerUser.email ?: @""};
    [manager POST:url
      parameters:params
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Success: %@", responseObject);
            BJCodeSuccessModel *userModel = [BJCodeSuccessModel yy_modelWithJSON:responseObject];
            if (success) {
                success(userModel);
            }
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error.localizedDescription);
            
            // 调用失败回调
            if (failure) {
                failure(error);
            }
        }];
}
- (void)submmitWithSuccess:(registerSuccess)success failure:(error)error {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = @"http://3.112.71.79:43223/register";
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary* dicty = @{@"email":self.registerUser.email, @"password":self.registerUser.password, @"code":self.registerUser.code};
    [manger POST:string parameters:dicty headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        BJRegisterSuccessModel* userModel = [BJRegisterSuccessModel yy_modelWithJSON:responseObject];
        NSLog(@"Success: %@", responseObject);
        if (success && userModel.status == 1000) {
            registerSuccess(userModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
