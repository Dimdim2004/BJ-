//
//  BJMyPageViedoModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/27.
//

#import "BJMyPageViedoModel.h"
#import "BJMyPageDealModel.h"

@implementation BJMyPageViedoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"favoriteCount":@"FavoriteCount", @"videoId":@"ID", @"imageCount":@"image_count", @"coverUrl":@"CoverURL", @"commentCount":@"CommentCount"};
}

- (BJMyPageDealModel*)changeToShowModel {
    BJMyPageDealModel* newModel = [[BJMyPageDealModel alloc] init];
    newModel.workId = self.videoId;
    newModel.title = self.title;
    newModel.content = self.title;
    newModel.likeCount = self.favoriteCount;
    newModel.userName = self.username;
    newModel.type = MyPagePosts;
    newModel.imagesURLAry = @[self.coverUrl];
    newModel.isFavourte = self.isFavourite;
    newModel.type = MyPageVideo;
    newModel.avatar = self.avatar;
    return newModel;
}
@end
