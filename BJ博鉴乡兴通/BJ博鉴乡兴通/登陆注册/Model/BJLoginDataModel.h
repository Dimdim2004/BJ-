//
//  BJLoginDataModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/10.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJLoginDataModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* token;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* avatar;
@end

NS_ASSUME_NONNULL_END
