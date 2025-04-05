//
//  BJMyPagePostModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import "BJMyPagePostModel.h"
#import "BJImageModel.h"
#import "BJMyPageDealModel.h"
@implementation BJMyPagePostModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"likeCount":@"like_count", @"postId":@"id", @"imageCount":@"image_count", @"timeString":@"created_at", @"avatar":@"user.avatar", @"userName":@"user.username"};
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"images":[BJImageModel class]};
}
- (BJMyPageDealModel*)changeToShowModel {
    BJMyPageDealModel* newModel = [[BJMyPageDealModel alloc] init];
    newModel.workId = self.postId;
    newModel.title = self.title;
    newModel.content = self.content;
    newModel.likeCount = self.likeCount;
    newModel.userName = self.username;
    newModel.type = MyPagePosts;
    newModel.imagesURLAry = self.images;
    newModel.isFavourte = self.isFavorite;
    newModel.avatar = self.avatar;
    newModel.commentCount = self.commentCount;
    return newModel;
}
@end
