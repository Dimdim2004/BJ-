//
//  BJForgetPasswordViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import "BJCheckEmailViewController.h"
#import "Masonry/Masonry.h"
#import "BJCheckEmailModel.h"
@interface BJCheckEmailViewController () {
    NSTimer* _timer;
    NSInteger _countingDown;
}

@end

@implementation BJCheckEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[BJCheckEmailViewModel alloc] init];
    [self setUI];
    [self setupBindings];
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_registerAccountTextField resignFirstResponder];
}
#pragma mark bindings
- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"user.email" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"user.email"]) {
        
        if (!self.viewModel.isValidEmail && self.viewModel.user.email) {
            [self showUserErrorLabel];
        } else if (self.viewModel.isValidEmail || self.viewModel.user.email.length == 0) {
            [self showSuccessUserLabel];
        }
    }
}
- (void)showUserErrorLabel {
    NSLog(@"邮箱格式错误");
    self.userErrorLabel.text = @"仅qq邮箱";
}
- (void)showSuccessUserLabel {
    self.userErrorLabel.text = @"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.viewModel.user.email = self.registerAccountTextField.text;
    NSLog(@"%@", self.viewModel.user.email);
}
#pragma mark UI&&Button
- (void)setUI {
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    UIColor* buttonColor = [UIColor colorWithRed:43.0 / 255.0 green:95.0 / 255.0 blue:51 / 255.0 alpha:1];
    self.view.backgroundColor = UIColor.greenColor;
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
    self.titleLabel.text = @"忘记密码";
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
    
    
    self.registerAccountTextField = [[UITextField alloc] init];
    self.registerAccountTextField.font = [UIFont systemFontOfSize:20];
    self.registerAccountTextField.placeholder = @"请输入邮箱";
    self.registerAccountTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerAccountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.registerAccountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerAccountTextField.backgroundColor = myColor;
    self.registerAccountTextField.delegate = self;
    
    
    
    
   
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeButton.layer.borderWidth = 2;
    self.codeButton.layer.cornerRadius = 20;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(checkEmail) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.backgroundColor = buttonColor;
    [self.codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.codeButton.enabled = YES;
    
    
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

    [self.backView addSubview:self.codeButton];

    [self.backView addSubview:self.registerAccountTextField];

    
    [_registerAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerAccountTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    
    
    self.userErrorLabel = [[UILabel alloc] init];
    self.userErrorLabel.text = @"";
    self.userErrorLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_userErrorLabel];
    self.userErrorLabel.textAlignment = NSTextAlignmentRight;
    self.userErrorLabel.textColor = UIColor.redColor;
    
    [self.userErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerAccountTextField.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.top.equalTo(self.registerAccountTextField.mas_top).offset(5);
    }];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"https://wap.mail.qq.com"];
        [UIApplication.sharedApplication openURL:url options:@{
            UIApplicationOpenURLOptionUniversalLinksOnly: @(NO)
        } completionHandler:^(BOOL success) {
            NSLog(@"openURL: %@", success ? @"YES" : @"NO");
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"邮箱验证失败" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)checkEmail {
    __weak id weakSelf = self;
    NSLog(@"123");
    [self.viewModel submmitWithSuccess:^(BJCheckEmailModel * _Nonnull userModel) {
            
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
