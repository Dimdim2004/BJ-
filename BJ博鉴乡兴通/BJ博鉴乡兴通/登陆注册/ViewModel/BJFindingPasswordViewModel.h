//
//  BJFindingPasswordViewModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/12.
//

#import <Foundation/Foundation.h>
@class BJFindPasswordSuccessModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJFindingPasswordViewModel : NSObject
typedef void(^findSuccess)(BJFindingPasswordViewModel* userModel);
typedef void(^error)(NSError* error);
@property (nonatomic, strong) BJFindPasswordSuccessModel* user;
@property (nonatomic, readonly) BOOL isVaildPassword;
@property (nonatomic, readonly) BOOL isVailSame;
@property (nonatomic, readonly) BOOL isVaildEmail;
- (void)submmitWithSuccess:(findSuccess)success failure:(error)error;
@property (nonatomic, assign) NSInteger authType;
- (instancetype)initWithAuthTyoe:(NSInteger)authType;
@end

NS_ASSUME_NONNULL_END
