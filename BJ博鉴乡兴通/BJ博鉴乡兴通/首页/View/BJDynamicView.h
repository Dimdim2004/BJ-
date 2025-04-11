//
//  BJDynamicViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/13.
//

#import <UIKit/UIKit.h>
@class BJDynamicModel,BJHomePageViewController;
NS_ASSUME_NONNULL_BEGIN


@interface BJDynamicView : UIView
@property (nonatomic, strong) UITableView *tableView;

@property (weak, nonatomic) BJHomePageViewController *scrollDelegate;
@end

NS_ASSUME_NONNULL_END
