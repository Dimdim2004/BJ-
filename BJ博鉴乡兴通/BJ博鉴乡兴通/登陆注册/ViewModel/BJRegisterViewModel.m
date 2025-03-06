//
//  BJRegisterModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import "BJRegisterViewModel.h"
#import "BJUserRegisterModel.h"
#import "BJRegisterSuccessModel.h"
#import "AFNetworking/AFNetworking.h"
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

- (void)submmitWithSuccess:(success)success failure:(error)error {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = @"";
    
    [manger POST:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        //BJRegisterSuccessModel* userModel = [BJRegisterSuccessModel yy_modelWithJSON:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)registerWithSuccess:(success)success failure:(error)error {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = @"";
    
    [manger POST:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        //BJRegisterSuccessModel* userModel = [BJRegisterSuccessModel yy_modelWithJSON:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
