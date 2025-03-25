//
//  BJUploadSuccessModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJUploadSuccessModel : NSObject
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, copy) NSString* data;
@end

NS_ASSUME_NONNULL_END
