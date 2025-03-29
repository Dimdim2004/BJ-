//
//  BJMyPageLikeModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import "BJMyPageLikeModel.h"
#import "BJMyPageViedoModel.h"
#import "BJMyPagePostModel.h"
@implementation BJMyPageLikeModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"videos":[BJMyPageViedoModel class], @"posts":[BJMyPagePostModel class]};
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"videos":@"data.vidoes", @"posts":@"data.posts"};
}
@end
