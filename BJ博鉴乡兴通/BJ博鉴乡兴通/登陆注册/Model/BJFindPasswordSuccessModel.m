//
//  BJFindPasswordSuccessModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJFindPasswordSuccessModel.h"

@implementation BJFindPasswordSuccessModel
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"password", @"rePassword", @"email"];
}
@end
