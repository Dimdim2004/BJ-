//
//  BJPostModel.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/11.
//

#import "BJDynamicModel.h"
#import "BJDynamicImageModel.h"
@implementation BJDynamicModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"avatarUrl" : @"user.avatar",
        @"userName" : @"user.username",
        @"postID" : @"post_id",
        @"numofLikes" : @"favorite_count",
        @"numofComment" : @"comment_count",
        @"isLiked" : @"is_favorite",
        @"timeText" : @"created_at"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"images" : [BJDynamicImageModel class]
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@", self.userName, self.avatarUrl, self.postID, self.postID, self.timeText];

}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *createdAt = dic[@"created_at"];
    if ([createdAt isKindOfClass:[NSString class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        NSDate *date = [formatter dateFromString:createdAt];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _timeText = [formatter stringFromDate:date];
    }
    return YES;
}
@end
