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
        @"countryID" : @"id",
        @"imageUrl": @"image"
    };
}

- (NSString *)description
{
    // 打印出model的所有内容
    return [NSString stringWithFormat:@"%@, %@ %ld",self.name, self.imageUrl,self.countryID];
    
}
@end
