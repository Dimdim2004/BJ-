//
//  BJFindPasswordViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/12.
//

#import <UIKit/UIKit.h>
#import "BJFindingPasswordViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJFindPasswordViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField* changeRepeatTextField;
@property (nonatomic, strong) UITextField* changePasswordTextField;
@property (nonatomic, strong) UIButton* changeButton;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* passwordErrorLabel;
@property (nonatomic, strong) UILabel* repeatErrorLabel;
@property (nonatomic, strong) BJFindingPasswordViewModel* viewModel;
@end

NS_ASSUME_NONNULL_END
