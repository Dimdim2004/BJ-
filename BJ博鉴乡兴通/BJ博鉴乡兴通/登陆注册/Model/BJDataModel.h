//
//  BJDataModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJDataModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString* username;
@end

NS_ASSUME_NONNULL_END
