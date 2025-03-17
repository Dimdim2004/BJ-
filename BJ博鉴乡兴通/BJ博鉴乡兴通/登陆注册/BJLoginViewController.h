//
//  LoginViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import <UIKit/UIKit.h>
@class BJLoginViewModel;
NS_ASSUME_NONNULL_BEGIN
@protocol tabControllDelgate <NSObject>

- (void)changeTab;

@end

@interface BJLoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField* usernameField;
@property (nonatomic, strong) UITextField* passwordField;
@property (nonatomic, strong) UIButton* submmitButton;
@property (nonatomic, strong) UIButton* registerButton;
@property (nonatomic, strong) UIButton* checkEmailButton;
@property (nonatomic, strong) UIButton* changePasswordButton;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* userErrorLabel;
@property (nonatomic, strong) UILabel* passwordErrorLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) BJLoginViewModel* viewModel;
@property (nonatomic, weak) id<tabControllDelgate> delegate;
@end

NS_ASSUME_NONNULL_END
