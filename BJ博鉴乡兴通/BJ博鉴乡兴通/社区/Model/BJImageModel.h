//
//  BJImageModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/19.
//

#import <Foundation/Foundation.h>
#import "YYModel/YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJImageModel : NSObject <YYModel>
@property (nonatomic, copy) NSString* url;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@end

NS_ASSUME_NONNULL_END
