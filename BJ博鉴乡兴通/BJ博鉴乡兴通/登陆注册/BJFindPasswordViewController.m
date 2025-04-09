//
//  BJFindPasswordViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/12.
//

#import "BJFindPasswordViewController.h"
#import "Masonry/Masonry.h"
#import "BJFindingPasswordViewModel.h"
#import "BJFindPasswordSuccessModel.h"
#import "BJLoginViewController.h"

@interface BJFindPasswordViewController ()

@end

@implementation BJFindPasswordViewController

- (void)viewDidLoad {
    [self setUI];
    [self setupBindings];
    self.view.backgroundColor = [UIColor clearColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    CGFloat y = height;
    NSLog(@"111");
    [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, - y + 160);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"user.password" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"user.rePassword" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"user.password"] || [keyPath isEqualToString:@"user.rePassword"]) {
        NSLog(@"111");
        self.changeButton.enabled = self.viewModel.isVailSame && self.viewModel.isVaildPassword;
        NSLog(@"%d, %d, %d", _changeButton.enabled, self.viewModel.isVailSame, self.viewModel.isVaildPassword);
        if (!self.viewModel.isVaildPassword && self.viewModel.user.password.length) {
            [self showPasswordErrorLabel];
        } else if (self.viewModel.isVaildPassword || self.viewModel.user.password.length == 0) {
            [self showPasswordSuccessLabel];
        }
        if (!self.viewModel.isVaildPassword && self.viewModel.user.rePassword.length) {
            [self showComfirmErrorLabel];
        } else if (self.viewModel.isVaildPassword || self.viewModel.user.rePassword.length == 0) {
            [self showComfirmSuccessLabel];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _changeRepeatTextField) {
        self.viewModel.user.rePassword = textField.text;
    } else {
        self.viewModel.user.password = textField.text;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_changeRepeatTextField resignFirstResponder];
    [_changePasswordTextField resignFirstResponder];
}
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
    if (self.viewModel.authType == 1) {
        self.titleLabel.text = @"忘记密码";
    } else {
        self.titleLabel.text = @"修改密码";
    }
    
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
    self.view.backgroundColor = UIColor.greenColor;
    self.changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.changeButton.layer.borderWidth = 2;
    [self.changeButton setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.changeButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.changeButton.tintColor = UIColor.whiteColor;
    self.changeButton.backgroundColor = buttonColor;
    self.changeButton.layer.cornerRadius = 20;
    self.changeButton.enabled = NO;
    self.changeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    
    
   
    
    self.changePasswordTextField = [[UITextField alloc] init];
    self.changePasswordTextField.font = [UIFont systemFontOfSize:20];
    self.changePasswordTextField.keyboardType = UIKeyboardTypeDefault;
    self.changePasswordTextField.placeholder = @"请输入密码";
    self.changePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.changePasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.changePasswordTextField.backgroundColor = myColor;
    self.changePasswordTextField.secureTextEntry = YES;
    self.changePasswordTextField.delegate = self;
    
    self.changeRepeatTextField = [[UITextField alloc] init];
    self.changeRepeatTextField.font = [UIFont systemFontOfSize:20];
    self.changeRepeatTextField.keyboardType = UIKeyboardTypeDefault;
    self.changeRepeatTextField.placeholder = @"请再次输入密码";
    self.changeRepeatTextField.textAlignment = NSTextAlignmentLeft;
    self.changeRepeatTextField.leftViewMode = UITextFieldViewModeAlways;
    self.changeRepeatTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.changeRepeatTextField.backgroundColor = myColor;
    self.changeRepeatTextField.secureTextEntry = YES;
    self.changeRepeatTextField.delegate = self;
    
    
    
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
   
    [self.backView addSubview:self.changeRepeatTextField];
    [self.backView addSubview:self.changePasswordTextField];
    [self.backView addSubview:self.changeButton];
    
    [_changePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    [_changeRepeatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changePasswordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeRepeatTextField.mas_bottom).offset(30);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];
    
    
    
    self.passwordErrorLabel = [[UILabel alloc] init];
    self.passwordErrorLabel.text = @"";
    self.passwordErrorLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_passwordErrorLabel];
    self.passwordErrorLabel.textAlignment = NSTextAlignmentRight;
    self.passwordErrorLabel.textColor = UIColor.redColor;
    
    self.repeatErrorLabel = [[UILabel alloc] init];
    self.repeatErrorLabel.text = @"";
    self.repeatErrorLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_repeatErrorLabel];
    self.repeatErrorLabel.textAlignment = NSTextAlignmentRight;
    self.repeatErrorLabel.textColor = UIColor.redColor;
    
    [self.passwordErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.changePasswordTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.changePasswordTextField.mas_top).offset(5);
    }];
    [self.repeatErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.changeRepeatTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.changeRepeatTextField.mas_top).offset(5);
    }];
    
}
- (void)showComfirmErrorLabel {
    self.repeatErrorLabel.text = @"两次密码不一致";
}
- (void)showComfirmSuccessLabel {
    self.repeatErrorLabel.text = @"";
}
- (void)showPasswordErrorLabel {
    self.passwordErrorLabel.text = @"大小写数字至少各1个";
}
- (void)showPasswordSuccessLabel {
    self.passwordErrorLabel.text = @"";
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController* vc = [self presentingViewController];
        while (vc.presentingViewController) {
            vc =  [vc presentingViewController];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"修改失败，网络错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)submitTapped {
    __weak id weakSelf = self;
    [self.viewModel submmitWithSuccess:^(BJFindingPasswordViewModel * _Nonnull userModel) {
        NSLog(@"success");
        [weakSelf showSuccessAlert];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
        [weakSelf showFailureAlert];
    }];
    
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
