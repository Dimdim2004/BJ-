//
//  BJRegisterViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import <UIKit/UIKit.h>
@class BJRegisterViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJRegisterViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField* registerAccountTextField;
@property (nonatomic, strong) UITextField* registerRepeatTextField;
@property (nonatomic, strong) UITextField* registerPasswordTextField;
@property (nonatomic, strong) UITextField* codeField;
@property (nonatomic, strong) UIButton* codeButton;
@property (nonatomic, strong) UIButton* registerButton;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextField* registerUserTextField;
@property (nonatomic, strong) UILabel* userErrorLabel;
@property (nonatomic, strong) UILabel* passwordErrorLabel;
@property (nonatomic, strong) UILabel* repeatErrorLabel;
@property (nonatomic, strong) BJRegisterViewModel* viewModel;
@end

NS_ASSUME_NONNULL_END
