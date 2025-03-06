//
//  BJRegisterViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/1.
//

#import "BJRegisterViewController.h"
#import "BJRegisterViewModel.h"
#import "BJUserRegisterModel.h"
@interface BJRegisterViewController () {
    NSTimer* _timer;
    NSInteger _countingDown;
}

@end

@implementation BJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupBindings];
    self.viewModel = [[BJRegisterViewModel alloc] init];
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
- (void)setUI {
    self.view.backgroundColor = UIColor.greenColor;
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth = 2;
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.frame = CGRectMake(120, 500, 140, 40);
    self.registerButton.tintColor = UIColor.whiteColor;
    self.registerButton.layer.cornerRadius = _registerButton.frame.size.width / 8;
    
    self.registerAccountTextField = [[UITextField alloc] init];
    self.registerAccountTextField.font = [UIFont systemFontOfSize:20];
    self.registerAccountTextField.frame = CGRectMake(80, 260, 240, 40);
    self.registerAccountTextField.placeholder = @"请输入邮箱";
    self.registerAccountTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerAccountTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjian-2.png"]];
    self.registerAccountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerAccountTextField.backgroundColor = UIColor.whiteColor;
    self.registerAccountTextField.delegate = self;
    
    self.registerPasswordTextField = [[UITextField alloc] init];
    self.registerPasswordTextField.font = [UIFont systemFontOfSize:20];
    self.registerPasswordTextField.frame = CGRectMake(80, 320, 240, 40);
    self.registerPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerPasswordTextField.placeholder = @"请输入密码";
    self.registerPasswordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghu.png"]];
    self.registerPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerPasswordTextField.backgroundColor = UIColor.whiteColor;
    self.registerPasswordTextField.delegate = self;
    
    self.registerRepeatTextField = [[UITextField alloc] init];
    self.registerRepeatTextField.font = [UIFont systemFontOfSize:20];
    self.registerRepeatTextField.frame = CGRectMake(80, 380, 240, 40);
    self.registerRepeatTextField.keyboardType = UIKeyboardTypeDefault;
    self.registerRepeatTextField.placeholder = @"请再次输入密码";
    self.registerRepeatTextField.textAlignment = NSTextAlignmentLeft;
    self.registerRepeatTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiesuo.png"]];
    self.registerRepeatTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerRepeatTextField.backgroundColor = UIColor.whiteColor;
    self.registerRepeatTextField.secureTextEntry = YES;
    self.registerRepeatTextField.delegate = self;
    
    self.codeField = [[UITextField alloc] init];
    self.codeField.font = [UIFont systemFontOfSize:20];
    self.codeField.placeholder = @"请输入验证码";
    self.codeField.leftViewMode = UITextFieldViewModeAlways;
    self.codeField.backgroundColor = UIColor.whiteColor;
    self.codeField.delegate = self;
    self.codeField.frame = CGRectMake(80, 440, 100, 40);
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeButton.layer.borderWidth = 2;
    [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.frame = CGRectMake(200, 440, 120, 40);
    self.codeButton.tintColor = UIColor.whiteColor;
    
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.registerRepeatTextField];
    [self.view addSubview:self.registerAccountTextField];
    [self.view addSubview:self.registerPasswordTextField];
    [self.view addSubview:self.registerButton];
}
- (void)sendCode {
    self.codeButton.selected = !self.codeButton.selected;
    self.codeButton.userInteractionEnabled = NO;
    [self setTimer];
}
- (void)setTimer {
    _countingDown = 60;
    self.codeButton.backgroundColor = UIColor.grayColor;
    [self.codeButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
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
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"注册失败，验证码错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showErrorAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"注册失败，密码或邮箱不符合要求" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)submitTapped {
    __weak id weakSelf = self;
    [self.viewModel submmitWithSuccess:^(BJSuccessModel * _Nonnull userModel) {
        [weakSelf showSuccessAlert];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error");
            
        }];
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
}
- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"isValidEmail" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"errorMessage" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_registerAccountTextField == textField) {
        self.viewModel.registerUser.email = textField.text;
    } else if (_registerRepeatTextField == textField) {
        self.viewModel.registerUser.password = textField.text;
    } else {
        self.viewModel.comfirmPassword = textField.text;
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
