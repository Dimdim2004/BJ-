//
//  CommentsModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/24.
//

#import "BJCommentsModel.h"
#import "BJSubCommentsModel.h"
@implementation BJCommentsModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"commentList":@"data.comment_list"};
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"commentList":[BJSubCommentsModel class]};
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"pageId"];
}
@end
