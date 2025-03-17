//
//  BJLoginSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
#import "BJDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJRegisterSuccessModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, strong) BJDataModel* data;
@end

NS_ASSUME_NONNULL_END
