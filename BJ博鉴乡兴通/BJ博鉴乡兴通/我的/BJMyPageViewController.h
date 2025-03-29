//
//  BJMyPageViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import <UIKit/UIKit.h>
@class BJMyPageLikeModel;
@class BJMyPageModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BJMyPageLikeModel* iModel;
@property (nonatomic, strong) BJMyPageModel* headModel;
@end

NS_ASSUME_NONNULL_END
