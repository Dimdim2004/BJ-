//
//  BJLocationModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/1.
//

#import "BJLocationModel.h"

@implementation BJLocationModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"countryID" : @"id",
    };
}

@end
