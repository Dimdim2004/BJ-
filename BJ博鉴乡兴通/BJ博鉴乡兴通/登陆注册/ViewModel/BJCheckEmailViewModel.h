//
//  BJForgetPasswordViewModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
@class BJCheckEmailModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJCheckEmailViewModel : NSObject
typedef void(^checkSuccess)(BJCheckEmailModel* userModel);
typedef void(^error)(NSError* error);
@property (nonatomic, strong) BJCheckEmailModel* user;
@property (nonatomic, readonly) BOOL isValidEmail;
- (void)submmitWithSuccess:(checkSuccess)success failure:(error)error;
@end

NS_ASSUME_NONNULL_END
