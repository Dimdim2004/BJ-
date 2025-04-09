//
//  BJDynamicImageModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/30.
//

#import "BJDynamicImageModel.h"

@implementation BJDynamicImageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"sortOrder" : @"sort_order"
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.url];
}
@end
