//
//  BJCommityModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJCommityModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, copy) NSArray* data;
@end

NS_ASSUME_NONNULL_END
