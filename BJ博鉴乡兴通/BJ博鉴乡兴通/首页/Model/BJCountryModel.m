//
//  BJCountryModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/23.
//

#import "BJCountryModel.h"

@implementation BJCountryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"countryDescription" : @"description",
        @"longitude" : @"lon",
        @"latitude" : @"lat",
        @"countryID" : @"id"
    };
}

@end
