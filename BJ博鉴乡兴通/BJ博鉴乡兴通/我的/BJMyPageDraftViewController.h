//
//  BJMyPageDraftViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/4/2.
//

#import <UIKit/UIKit.h>
@class BJMainCommunityView;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyPageDraftViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BJMainCommunityView* iView;
@property (nonatomic, strong) NSMutableArray* heightAry;
@property (nonatomic, strong) NSMutableArray* calucateAry;
@property (nonatomic, strong) NSMutableArray* imageAry;
@property (nonatomic, strong) NSArray* model;
@end

NS_ASSUME_NONNULL_END
