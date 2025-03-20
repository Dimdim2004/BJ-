//
//  BJMyPgaeModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJMyPgaeModel : NSObject
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, assign) NSInteger concernedCount;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger atricleCount;
@end

NS_ASSUME_NONNULL_END
