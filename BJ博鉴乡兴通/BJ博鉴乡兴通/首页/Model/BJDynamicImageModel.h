//
//  BJDynamicImageModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/30.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJDynamicImageModel : NSObject<YYModel>
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger sortOrder;
@end


NS_ASSUME_NONNULL_END
