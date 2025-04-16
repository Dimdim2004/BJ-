//
//  BJRegisterViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import "BJRegisterViewController.h"
#import "BJRegisterViewModel.h"
#import "BJUserRegisterModel.h"
#import "Masonry/Masonry.h"
#import "BJDataModel.h"
#import "BJLoginViewController.h"
@interface BJRegisterViewController () {
    NSTimer* _timer;
    NSInteger _countingDown;
}

@end

@implementation BJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.viewModel = [[BJRegisterViewModel alloc] init];
    [self setupBindings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    CGFloat y = height;
    [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, - y + 160);
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"registerUser.email"] || [keyPath isEqualToString:@"registerUser.password"] || [keyPath isEqualToString:@"registerUser.code"] || [keyPath isEqualToString:@"registerUser.name"] || [keyPath isEqualToString:@"comfirmPassword"]) {
        
        BOOL isNull = (self.viewModel.registerUser.email.length == 0)
                     || (self.viewModel.registerUser.password.length == 0)
                     || !(self.viewModel.registerUser.code)
                     || (self.viewModel.registerUser.name.length == 0)
                     || (self.viewModel.comfirmPassword.length == 0);
        self.registerButton.enabled = self.viewModel.isValidRegister && !isNull;
        if (!self.viewModel.isValidEmail && self.viewModel.registerUser.email.length) {
            [self showEmailErrorLabel];
        } else if (self.viewModel.isValidEmail || self.viewModel.registerUser.email.length == 0) {
            [self showEmailSuccessLabel];
        }
        if (!self.viewModel.isValidPassword && self.viewModel.registerUser.password.length) {
            [self showPasswordErrorLabel];
        } else if (self.viewModel.isValidPassword || self.viewModel.registerUser.password.length == 0) {
            [self showPasswordSuccessLabel];
        }
        if (!self.viewModel.isValidComfirm && self.viewModel.comfirmPassword.length) {
            [self showComfirmErrorLabel];
        } else if (self.viewModel.isValidComfirm || self.viewModel.comfirmPassword.length == 0) {
            [self showComfirmSuccessLabel];
        }
    }
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark UI
- (void)setUI {
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    UIColor* buttonColor = [UIColor colorWithRed:43.0 / 255.0 green:95.0 / 255.0 blue:51 / 255.0 alpha:1];
    self.backView = [[UIView alloc] init];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 30;
    self.backView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@560);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"邮箱注册";
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    self.titleLabel.tintColor = UIColor.greenColor;
    [_backView addSubview:_titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(@0).offset(30);
        make.width.equalTo(@160);
        make.height.equalTo(@100);
    }];
    self.view.backgroundColor = UIColor.clearColor;
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth = 2;
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.tintColor = UIColor.whiteColor;
    self.registerButton.backgroundColor = buttonColor;
    self.registerButton.layer.cornerRadius = 20;
    self.registerButton.enabled = NO;
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    self.registerAccountTextField = [[UITextField alloc] init];
    self.registerAccountTextField.font = [UIFont systemFontOfSize:20];
    self.registerAccountTextField.placeholder = @"请输入邮箱";
    self.registerAccountTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerAccountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.registerAccountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerAccountTextField.backgroundColor = myColor;
    self.registerAccountTextField.delegate = self;
    
    self.registerUserTextField = [[UITextField alloc] init];
    self.registerUserTextField.font = [UIFont systemFontOfSize:20];
    self.registerUserTextField.placeholder = @"用户名";
    self.registerUserTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerUserTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerUserTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.registerUserTextField.backgroundColor = myColor;
    self.registerUserTextField.delegate = self;
    
    self.registerPasswordTextField = [[UITextField alloc] init];
    self.registerPasswordTextField.font = [UIFont systemFontOfSize:20];
    self.registerPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerPasswordTextField.placeholder = @"请输入密码";
    self.registerPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerPasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.registerPasswordTextField.backgroundColor = myColor;
    self.registerPasswordTextField.secureTextEntry = YES;
    self.registerPasswordTextField.delegate = self;
    
    self.registerRepeatTextField = [[UITextField alloc] init];
    self.registerRepeatTextField.font = [UIFont systemFontOfSize:20];
    self.registerRepeatTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerRepeatTextField.placeholder = @"请再次输入密码";
    self.registerRepeatTextField.textAlignment = NSTextAlignmentLeft;
    self.registerRepeatTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerRepeatTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.registerRepeatTextField.backgroundColor = myColor;
    self.registerRepeatTextField.secureTextEntry = YES;
    self.registerRepeatTextField.delegate = self;
    
    self.codeField = [[UITextField alloc] init];
    self.codeField.font = [UIFont systemFontOfSize:20];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
    self.codeField.backgroundColor = myColor;
    self.codeField.delegate = self;
    self.codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeButton.layer.borderWidth = 2;
    [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.backgroundColor = UIColor.whiteColor;
    [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(20);
        make.top.equalTo(self.backView).offset(20);
        make.height.width.equalTo(@30);
    }];
    
    [self.backView addSubview:button];
    [self.backView addSubview:self.codeField];
    [self.backView addSubview:self.codeButton];
    [self.backView addSubview:self.registerUserTextField];
    [self.backView addSubview:self.registerRepeatTextField];
    [self.backView addSubview:self.registerAccountTextField];
    [self.backView addSubview:self.registerPasswordTextField];
    [self.backView addSubview:self.registerButton];
    
    [_registerUserTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [_registerAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerUserTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [_registerPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerAccountTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [_registerRepeatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerPasswordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerRepeatTextField.mas_bottom).offset(10);
        make.left.equalTo(self.registerRepeatTextField);
        make.width.equalTo(@180);
        make.height.equalTo(@40);
    }];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeField);
        make.left.equalTo(self.codeField.mas_right).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];
    
    self.userErrorLabel = [[UILabel alloc] init];
    self.userErrorLabel.text = @"";
    self.userErrorLabel.font = [UIFont systemFontOfSize:10];
    [_backView addSubview:_userErrorLabel];
    self.userErrorLabel.textAlignment = NSTextAlignmentRight;
    self.userErrorLabel.textColor = UIColor.redColor;
    
    self.passwordErrorLabel = [[UILabel alloc] init];
    self.passwordErrorLabel.text = @"";
    self.passwordErrorLabel.font = [UIFont systemFontOfSize:10];
    [_backView addSubview:_passwordErrorLabel];
    self.passwordErrorLabel.textAlignment = NSTextAlignmentRight;
    self.passwordErrorLabel.numberOfLines = 2;
    self.passwordErrorLabel.textColor = UIColor.redColor;
    
    self.repeatErrorLabel = [[UILabel alloc] init];
    self.repeatErrorLabel.text = @"";
    self.repeatErrorLabel.font = [UIFont systemFontOfSize:10];
    
    [_backView addSubview:_repeatErrorLabel];
    self.repeatErrorLabel.textAlignment = NSTextAlignmentRight;
    self.repeatErrorLabel.textColor = UIColor.redColor;
    
    [self.userErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerAccountTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.registerAccountTextField.mas_top).offset(5);
    }];
    [self.passwordErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerPasswordTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.registerPasswordTextField.mas_top).offset(5);
    }];
    [self.repeatErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerRepeatTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.registerRepeatTextField.mas_top).offset(5);
    }];
    
}
#pragma mark Button
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendCode {
    self.codeButton.selected = !self.codeButton.selected;
    self.codeButton.userInteractionEnabled = NO;
    self.viewModel.registerUser.email = self.registerAccountTextField.text;
    [self setTimer];
    [self.viewModel sendCodeWithSuccess:^(BJCodeSuccessModel * _Nonnull userModel) {
        NSLog(@"%@", userModel);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
- (void)setTimer {
    _countingDown = 60;
    [self.codeButton setTitleColor:UIColor.darkGrayColor forState:UIControlStateSelected];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重试", _countingDown] forState:UIControlStateSelected];
}
- (void)countDown {
    if (_countingDown <= 0) {
        [self resetButton];
    } else {
        NSLog(@"1");
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重试", --_countingDown] forState:UIControlStateSelected];
    }
}
- (void)showSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController* vc = [self presentingViewController];
        while (vc.presentingViewController) {
            vc =  [vc presentingViewController];
        }
        BJLoginViewController* loginViewController = (BJLoginViewController*) vc;
        loginViewController.usernameField.text = self.viewModel.registerUser.email;
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"注册失败，验证码错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"注册失败，密码或邮箱不符合要求，密码要求是大小写字符和数字至少各一个且长度不低于6个字符" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showComfirmErrorLabel {
    self.repeatErrorLabel.text = @"两次密码不一致";
}
- (void)showComfirmSuccessLabel {
    self.repeatErrorLabel.text = @"";
}
- (void)showPasswordErrorLabel {
    self.passwordErrorLabel.text = @"大小写数字至少各1个,最短6位";
}
- (void)showPasswordSuccessLabel {
    self.passwordErrorLabel.text = @"";
}
- (void)showEmailErrorLabel {
    self.userErrorLabel.text = @"仅限qq邮箱";
}
- (void)showEmailSuccessLabel {
    self.userErrorLabel.text = @"";
}

- (void)submitTapped {
    if (!self.viewModel.isValidRegister) {
        [self showComfirmErrorLabel];
    } else {
        __weak id weakSelf = self;
        NSLog(@"%@, %@, %@", self.viewModel.registerUser.password, self.viewModel.registerUser.email, self.viewModel.registerUser.code);
        [self.viewModel submmitWithSuccess:^(BJRegisterSuccessModel * _Nonnull userModel) {
            [weakSelf showSuccessAlert];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error");
            [weakSelf showFailureAlert];
        }];
    }
}
- (void)resetButton {
    [_timer invalidate];
    _timer = nil;
    self.codeButton.userInteractionEnabled = YES;
    self.codeButton.selected = NO;
    self.codeButton.backgroundColor = UIColor.clearColor;
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_registerRepeatTextField resignFirstResponder];
    [_registerAccountTextField resignFirstResponder];
    [_registerPasswordTextField resignFirstResponder];
    [_registerUserTextField resignFirstResponder];
    [_codeField resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_registerAccountTextField == textField) {
        self.viewModel.registerUser.email = textField.text;
    } else if (_registerPasswordTextField == textField) {
        self.viewModel.registerUser.password = textField.text;
    } else if (_registerRepeatTextField == textField){
        self.viewModel.comfirmPassword = textField.text;
    } else if (_registerUserTextField == textField) {
        self.viewModel.registerUser.name = textField.text;
    } else {
        self.viewModel.registerUser.code = textField.text;
    }
}

- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"registerUser.email" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"registerUser.password" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"registerUser.code" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"registerUser.name" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"comfirmPassword" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.viewModel removeObserver:self forKeyPath:@"registerUser.email"];
    [self.viewModel removeObserver:self forKeyPath:@"registerUser.password"];
    [self.viewModel removeObserver:self forKeyPath:@"registerUser.code"];
    [self.viewModel removeObserver:self forKeyPath:@"registerUser.name"];
    [self.viewModel removeObserver:self forKeyPath:@"comfirmPassword"];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _registerPasswordTextField || textField == _registerRepeatTextField) {
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
    } else if (textField == _registerAccountTextField) {
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
    } else if (textField == _registerUserTextField) {
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 10) {
            textField.text = [textField.text substringToIndex:10];
            return NO;
        } else if ( textField.text.length <= 10) {
            return YES;
        }
        return NO;
    } else {
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
            return NO;
        } else if ([string isEqualToString:filteredStr] && textField.text.length <= 6) {
            return YES;
        }
        return NO;
    }
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
