//
//  BJMyPageViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import <UIKit/UIKit.h>
@class BJMyPageLikeModel;
@class BJMyPageModel;
@class BJMyPageDealModel;
NS_ASSUME_NONNULL_BEGIN
@protocol updateDataDelegate;

@interface BJMyPageViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, updateDataDelegate>
@property (nonatomic, strong) NSMutableArray<BJMyPageDealModel*>* iModel;
@property (nonatomic, strong) BJMyPageModel* headModel;
@end

NS_ASSUME_NONNULL_END
