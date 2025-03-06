//
//  BJRegisterSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
@class BJDataModel;
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJRegisterSuccessModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, strong) BJDataModel* dataModel;
@end

NS_ASSUME_NONNULL_END
