//
//  BJForgetPasswordModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCheckEmailModel.h"

@implementation BJCheckEmailModel
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"email"];
}
@end
