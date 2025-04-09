//
//  BJMyPageDealModel.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/29.
//

#import "BJMyPageDealModel.h"
#import "BJCommityDataModel.h"
@implementation BJMyPageDealModel
- (BJCommityDataModel*)changeToShowModel {
    BJCommityDataModel* newModel = [[BJCommityDataModel alloc] init];
    newModel.postId = self.workId;
    newModel.title = self.title;
    newModel.content = self.title;
    newModel.favoriteCount = self.likeCount;
    newModel.username = self.userName;
    newModel.avatar = self.avatar;
    newModel.images = self.imagesURLAry;
    newModel.imageCount = self.imagesURLAry.count;
    newModel.isFavorite = self.isFavourte;
    newModel.isFollowing = NO;
    return newModel;
}
@end
