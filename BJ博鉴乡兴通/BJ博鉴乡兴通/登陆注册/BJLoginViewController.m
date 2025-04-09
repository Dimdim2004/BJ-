//
//  LoginViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/2/27.
//

#import "BJLoginViewController.h"
#import "BJLoginViewModel.h"
#import "BJUserModel.h"
#import "BJRegisterViewController.h"
#import "Masonry/Masonry.h"
#import "BJCheckEmailViewController.h"
#import "BJNetworkingManger.h"
#import "BJLoginSuccessModel.h"
#import "BJFindPasswordViewController.h"
#import "BJLoginDataModel.h"
@interface BJLoginViewController ()
@property (strong, nonatomic)UILabel *logoLabel;
@end

@implementation BJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[BJLoginViewModel alloc] init];
    [self setUI];
    [self setupBindings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    // Do any additional setup after loading the view.
}
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    CGFloat y = height;
    [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, - y + 160);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark UI
- (void) setUI {
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackView.png"]];
    self.backView = [[UIView alloc] init];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 30;
    self.backView.backgroundColor = UIColor.whiteColor;
    self.backView.alpha = 0.95;
    [self.view addSubview:_backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@500);
    }];
    
    self.logoLabel = [[UILabel alloc] init];
    self.logoLabel.text = @"原乡云道";
    self.logoLabel.font = [UIFont fontWithName:@"Joyfonts-QinglongGB-Flash-Black" size:75];
    self.logoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.logoLabel];
    
    self.logoLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"邮箱登陆";
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    self.titleLabel.textColor = UIColor.blackColor;

    [_backView addSubview:_titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0).offset(60);
        make.width.equalTo(@200);
        make.height.equalTo(@70);
    }];
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.font = [UIFont systemFontOfSize:20];
    self.usernameField.placeholder = @"请输入邮箱";
    self.usernameField.tag = 1;
    self.usernameField.keyboardType = UIKeyboardTypeDefault;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    self.usernameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.usernameField.backgroundColor = myColor;
    self.usernameField.delegate = self;
    [_backView addSubview:_usernameField];
    [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    self.usernameField.layer.masksToBounds = YES;
    self.usernameField.layer.cornerRadius = 10;
//
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.font = [UIFont systemFontOfSize:20];
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.tag = 2;
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.backgroundColor = myColor;
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
   
    self.passwordField.delegate = self;
    [_backView addSubview:_passwordField];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.usernameField.mas_bottom).offset(20);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.backView.mas_top).offset(-70);
    }];
    self.passwordField.layer.masksToBounds = YES;
    self.passwordField.layer.cornerRadius = 10;
//
    self.submmitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submmitButton.enabled = NO;
    UIColor* buttonColor = [UIColor colorWithRed:43.0 / 255.0 green:95.0 / 255.0 blue:51 / 255.0 alpha:1];
    self.submmitButton.backgroundColor = buttonColor;
    self.submmitButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.submmitButton.layer.borderWidth = 2;
    self.submmitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submmitButton setTitle:@"登陆" forState:UIControlStateNormal];
    
    self.submmitButton.tintColor = UIColor.whiteColor;
    //self.submmitButton.frame = CGRectMake(100, 460, 80, 40);
    self.submmitButton.layer.cornerRadius = 20;
    [self.submmitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_submmitButton];
    [_submmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordField.mas_bottom).offset(40);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];
//
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.backgroundColor = UIColor.whiteColor;
    [self.registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.registerButton addTarget:self action:@selector(presentRegister) forControlEvents:UIControlEventTouchUpInside];
    //self.registerButton.frame = CGRectMake(200, 460, 80, 40);
    self.registerButton.tintColor = UIColor.lightGrayColor;
    [_backView addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.submmitButton.mas_bottom).offset(10);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];
    UIButton* quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [quickButton addTarget:self action:@selector(quickPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickButton];
    [quickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(45);
        make.height.equalTo(@80);
        make.width.equalTo(@100);
    }];
    
    self.userErrorLabel = [[UILabel alloc] init];
    self.userErrorLabel.text = @"";
    self.userErrorLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_userErrorLabel];
    self.userErrorLabel.textAlignment = NSTextAlignmentRight;
    self.userErrorLabel.textColor = UIColor.redColor;
    
    self.passwordErrorLabel = [[UILabel alloc] init];
    self.passwordErrorLabel.text = @"";
    self.passwordErrorLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_passwordErrorLabel];
    self.passwordErrorLabel.textAlignment = NSTextAlignmentRight;
    self.passwordErrorLabel.textColor = UIColor.redColor;
    
    [self.userErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.usernameField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.usernameField.mas_top).offset(5);
    }];
    [self.passwordErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.passwordField.mas_top).offset(5);
    }];
    
    
    self.checkEmailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.checkEmailButton.backgroundColor = UIColor.whiteColor;
    [self.checkEmailButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.checkEmailButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.checkEmailButton addTarget:self action:@selector(presentCheck) forControlEvents:UIControlEventTouchUpInside];
    //self.registerButton.frame = CGRectMake(200, 460, 80, 40);
    self.checkEmailButton.tintColor = UIColor.lightGrayColor;
    [_backView addSubview:_checkEmailButton];
    [_checkEmailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordField.mas_right).offset(10);
        make.top.equalTo(self.passwordField.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    self.changePasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changePasswordButton.backgroundColor = UIColor.whiteColor;
    [self.changePasswordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    self.changePasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.changePasswordButton addTarget:self action:@selector(presentChange) forControlEvents:UIControlEventTouchUpInside];
    //self.registerButton.frame = CGRectMake(200, 460, 80, 40);
    self.changePasswordButton.tintColor = UIColor.lightGrayColor;
    [_backView addSubview:_changePasswordButton];
    [_changePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordField.mas_left).offset(-10);
        make.top.equalTo(self.passwordField.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
}

- (void)presentCheck {
    BJCheckEmailViewController* checkEmailViewController = [[BJCheckEmailViewController alloc] init];
    [self presentViewController:checkEmailViewController animated:YES completion:nil];
}

- (void)presentChange {
    BJFindPasswordViewController* changePasswordViewController = [[BJFindPasswordViewController alloc] init];
    BJFindingPasswordViewModel* changeModel = [[BJFindingPasswordViewModel alloc] initWithAuthTyoe:0];
    [self presentViewController:changePasswordViewController animated:YES completion:nil];
}

- (void)quickPush {
    [self.delegate changeTab];
}
-(void)presentRegister {

    BJRegisterViewController* registerViewController = [[BJRegisterViewController alloc] init];
    [self presentViewController:registerViewController animated:YES completion:nil];
}
- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"user.email" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"user.password" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"user.email"] || [keyPath isEqualToString:@"user.password"]) {
        self.submmitButton.enabled = self.viewModel.isValidLogin;
        
        if (!self.viewModel.isValidEmail && self.viewModel.user.email.length) {
            [self showUserErrorLabel];
        } else if (self.viewModel.isValidEmail || self.viewModel.user.email.length == 0) {
            [self showSuccessUserLabel];
        }
        if (!self.viewModel.isValidPassword && self.viewModel.user.password.length) {
            [self showPasswordErrorLabel];
        } else if (self.viewModel.isValidPassword || self.viewModel.user.password.length == 0) {
            [self showSuccessPaasswordLabel];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _passwordField) {
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 15) {
            textField.text = [textField.text substringToIndex:15];
            return NO;
        } else if ([string isEqualToString:filteredStr] && textField.text.length <= 15) {
            return YES;
        }
        return NO;
    } else {
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"@.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 19) {
            textField.text = [textField.text substringToIndex:19];
            return NO;
        } else if ([string isEqualToString:filteredStr] && textField.text.length <= 19) {
            return YES;
        }
        return NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _usernameField) {
        self.viewModel.user.email = textField.text;
    } else {
        self.viewModel.user.password = textField.text;
    }
    NSLog(@"当前是否可以登陆。%d", self.viewModel.isValidLogin);
}
- (void)showSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.delegate changeTab];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"登陆失败，密码或邮箱错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showSuccessUserLabel {
    self.userErrorLabel.text = @"";
}
- (void)showSuccessPaasswordLabel {
    self.passwordErrorLabel.text = @"";
}
- (void)showUserErrorLabel {
    NSLog(@"邮箱格式错误");
    self.userErrorLabel.text = @"仅qq邮箱";
}
- (void)showPasswordErrorLabel {
    NSLog(@"密码格式错误");
    self.passwordErrorLabel.text = @"密码格式错误";
}
- (void)submitTapped {
    __weak id weakSelf = self;
    
    [self.viewModel submmitWithSuccess:^(BJLoginSuccessModel * _Nonnull userModel) {
        [weakSelf showSuccessAlert];
        [BJNetworkingManger sharedManger].token = userModel.data.token;
        } failure:^(NSError * _Nonnull error) {
            [weakSelf showFailureAlert];
            NSLog(@"error");
        }];
}
- (void)dealloc {
    [self.viewModel removeObserver:self forKeyPath:@"user.email"];
    [self.viewModel removeObserver:self forKeyPath:@"user.password"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}
/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
