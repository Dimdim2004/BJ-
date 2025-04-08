//
//  BJCommunityViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import <UIKit/UIKit.h>
#import "BJMainCommunityView.h"
@class BJCommityModel;
NS_ASSUME_NONNULL_BEGIN
@protocol updateDataDelegate <NSObject>
-(void)updateFavourite:(NSInteger)isFavourite andCommentCount:(NSInteger)commentCount withWorkId:(NSInteger)workId;
@end
@interface BJCommunityViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDataSourcePrefetching, updateDataDelegate>
@property (nonatomic, strong) BJMainCommunityView* iView;
@property (nonatomic, strong) NSMutableArray* model;
@end

NS_ASSUME_NONNULL_END
