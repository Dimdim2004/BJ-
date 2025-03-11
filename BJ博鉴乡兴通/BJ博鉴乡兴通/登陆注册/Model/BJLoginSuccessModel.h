//
//  BJLoginSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/10.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
@class BJLoginDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJLoginSuccessModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, strong) BJLoginDataModel* data;
@end

NS_ASSUME_NONNULL_END
