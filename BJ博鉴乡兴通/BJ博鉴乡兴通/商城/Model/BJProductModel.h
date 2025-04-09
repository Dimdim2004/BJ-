//
//  BJProductModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJProductModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageURL;

+ (NSArray<BJProductModel *> *)productsWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
