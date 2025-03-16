//
//  UserModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJUserModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* password;
@end

NS_ASSUME_NONNULL_END
