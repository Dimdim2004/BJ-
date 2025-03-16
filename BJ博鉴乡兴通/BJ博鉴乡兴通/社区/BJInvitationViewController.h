//
//  BJInvitationViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/2.
//

#import <UIKit/UIKit.h>
#import "BJInvitationView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJInvitationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BJInvitationView* iView;
@end

NS_ASSUME_NONNULL_END
