//
//  BJPreviewlViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/18.
//

#import <UIKit/UIKit.h>
@class BJPreviewModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJPreviewlViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView* mainView;
@property (nonatomic, strong) UIButton* postButton;
@property (nonatomic, strong) NSArray<UIImage*>* photos;
@property (nonatomic, strong) UIPageControl* page;
@property (nonatomic, strong) BJPreviewModel* model;
@end

NS_ASSUME_NONNULL_END
