//
//  BJInvitationViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/2.
//

#import <UIKit/UIKit.h>
#import "BJInvitationView.h"
#import "BJCommentsModel.h"
#import "BJCommityDataModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol updateDataDelegate;
@interface BJInvitationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate, UITableViewDataSourcePrefetching>
@property (nonatomic, strong) BJInvitationView* iView;
@property (nonatomic, strong) NSMutableDictionary* dary;
@property (nonatomic, strong) BJCommentsModel* commentModel;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSMutableDictionary* dicty;
@property (nonatomic, strong) BJCommityDataModel* commityModel;
@property (nonatomic, strong) UIPageControl* page;
@property (nonatomic, assign) NSInteger workId;
@property (nonatomic, weak) id<updateDataDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
