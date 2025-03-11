//
//  BJRegisterSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
@class BJCodeModel;
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJCodeSuccessModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, strong) BJCodeModel* dataModel;
@end

NS_ASSUME_NONNULL_END
