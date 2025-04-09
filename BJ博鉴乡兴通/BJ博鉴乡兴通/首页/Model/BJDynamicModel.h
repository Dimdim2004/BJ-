//
//  BJPostModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/11.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
NS_ASSUME_NONNULL_BEGIN
@class BJDynamicImageModel;
@interface BJDynamicModel : NSObject<YYModel>
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray<BJDynamicImageModel *> *images;
@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, copy) NSString *numofLikes;
@property (nonatomic, copy) NSString *numofComment;
@property (nonatomic, copy) NSString *numofShare;
@property (nonatomic, assign) BOOL isLiked;
@end



NS_ASSUME_NONNULL_END
