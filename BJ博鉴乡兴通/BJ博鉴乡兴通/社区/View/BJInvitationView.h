//
//  BJInvitationView.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJInvitationView : UIView
@property (nonatomic, strong) UITableView* mainView;
@property (nonatomic, strong) UITextView* commentTextView;
@property (nonatomic, strong) UIView* toolBar;
@property (nonatomic, strong) UIButton* postButton;
@property (nonatomic, strong) UIView* backView;
- (void)setToolBar;
@end

NS_ASSUME_NONNULL_END
