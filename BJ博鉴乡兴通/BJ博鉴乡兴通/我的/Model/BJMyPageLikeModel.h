//
//  BJMyPageLikeModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageLikeModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, copy) NSArray* videos;
@property (nonatomic, copy) NSArray* posts;
@end

NS_ASSUME_NONNULL_END
