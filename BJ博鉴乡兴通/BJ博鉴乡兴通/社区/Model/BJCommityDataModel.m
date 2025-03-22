//
//  BJCommityDataModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/19.
//

#import "BJCommityDataModel.h"
#import "BJImageModel.h"
@implementation BJCommityDataModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"postId":@"post_id", @"avatar":@"user.avatar", @"timeString":@"created_at", @"username":@"user.username",  @"commentCount":@"comment_count",  @"favoriteCount":@"favorite_count", @"isFavorite":@"is_favorite"};
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"isExpand"];
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"images":[BJImageModel class]};
}
@end
