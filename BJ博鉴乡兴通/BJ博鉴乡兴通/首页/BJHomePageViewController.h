//
//  BJHomePageViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol dynamicViewDidReachTopAndScrollUpDelegate <NSObject>

-(void)dynamicViewDidReachTopAndScrollUp;

@end
@interface BJHomePageViewController : UIViewController<UITableViewDelegate>

@end

NS_ASSUME_NONNULL_END
