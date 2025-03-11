//
//  BJUserRegisterModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJUserRegisterModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* name;
@end

NS_ASSUME_NONNULL_END
