//
//  UserModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import "BJUserModel.h"

@implementation BJUserModel
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"isRember"];
}
@end
