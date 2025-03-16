//
//  BJRegisterModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
@class BJUserRegisterModel;
@class BJSuccessModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^success)(BJSuccessModel* userModel);
typedef void(^error)(NSError* error);
@interface BJRegisterViewModel : NSObject
@property (nonatomic, assign) NSInteger authType;
@property (nonatomic, strong) BJUserRegisterModel* registerUser;
@property (nonatomic, readonly) BOOL isValidEmail;
@property (nonatomic, readonly) BOOL isValidPassword;
@property (nonatomic, readonly) BOOL isValidRegister;

@property (nonatomic, readonly) BOOL isSendCode;
@property (nonatomic, copy) NSString* comfirmPassword;
- (void)submmitWithSuccess:(success)success failure:(error)error;
@end

NS_ASSUME_NONNULL_END
