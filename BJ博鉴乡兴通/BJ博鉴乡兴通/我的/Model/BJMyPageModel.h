//
//  BJMyPgaeModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/19.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger following;
@property (nonatomic, assign) NSInteger workCount;
@end

NS_ASSUME_NONNULL_END
