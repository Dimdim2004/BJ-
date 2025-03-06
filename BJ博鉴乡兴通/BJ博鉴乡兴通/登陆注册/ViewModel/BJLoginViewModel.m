//
//  AuthViewModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import "BJLoginViewModel.h"
#import "BJUserModel.h"
#import "BJSuccessModel.h"
#import "AFNetworking/AFNetworking.h"
@implementation BJLoginViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[BJUserModel alloc] init];
    }
    return self;
}
- (BOOL)isValidEmail {
    NSString *email = self.user.email;
    NSString *pattern = @"^[1-9][0-9]{4,}@qq\\.com$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:email];
}
- (BOOL) isValidPassword {
    NSString *pattern = @"^(?=.*[A-Z])(?=.*[a-z])[A-Za-z0-9]{6,}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self.user.password];
    return isMatch && self.user.password.length >= 6;
}
- (BOOL)isValidLogin {
    return self.isValidEmail && self.isValidPassword;
}
- (void)submmitWithSuccess:(success)success failure:(error)error {
    AFHTTPSessionManager* manger = [AFHTTPSessionManager manager];
    NSString* string = @"";
    
    [manger POST:string parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
