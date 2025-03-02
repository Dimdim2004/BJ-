//
//  AuthViewModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import <Foundation/Foundation.h>
@class BJUserModel;
@class BJSuccessModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^success)(BJSuccessModel* successModel);
typedef void(^error)(NSError* error);
@interface BJLoginViewModel : NSObject
@property (nonatomic, strong) BJUserModel* user;
@property (nonatomic, readonly) BOOL isValidEmail;
@property (nonatomic, readonly) BOOL isValidPassword;
@property (nonatomic, readonly) BOOL isValidLogin;

- (void)submmitWithSuccess:(success)success failure:(error)error;
@end

NS_ASSUME_NONNULL_END
