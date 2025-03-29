//
//  SubCommentsModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/24.
//

#import "BJSubCommentsModel.h"

@implementation BJSubCommentsModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"commentId":@"id", @"replyId":@"reply_to_id", @"timeString":@"created_at", @"replyToUsername":@"reply_to_username", @"userId":@"user_id"};
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"isExpand", @"isLike"];
}

@end
