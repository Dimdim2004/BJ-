//
//  BJProductModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/7.
//

#import "BJProductModel.h"

@implementation BJProductModel



+ (NSArray<BJProductModel *> *)productsWithArray:(NSArray *)array {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        BJProductModel *model = [[BJProductModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [models addObject:model];
    }
    return [models copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"⚠️ 未定义键值映射: %@", key);
}
@end
