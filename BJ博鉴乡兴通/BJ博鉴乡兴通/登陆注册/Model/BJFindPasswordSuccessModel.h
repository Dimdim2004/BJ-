//
//  BJFindPasswordSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJFindPasswordSuccessModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* rePassword;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* message;
@end

NS_ASSUME_NONNULL_END
