//
//  BJMyPgaeModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/19.
//

#import "BJMyPageModel.h"

@implementation BJMyPageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"workCount":@"data.work_count", @"username":@"data.username", @"avatar":@"data.avatar", @"followers":@"data.followers", @"following":@"data.following"};
}
@end
