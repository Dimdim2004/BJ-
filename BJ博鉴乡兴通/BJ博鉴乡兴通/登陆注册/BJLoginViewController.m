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
@interface BJLoginViewController ()

@end

@implementation BJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupBindings];
    self.viewModel = [[BJLoginViewModel alloc] init];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    // Do any additional setup after loading the view.
}
//- (void)keyboardWillShow:(NSNotification *)notification {
//    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat height = frame.size.height;
//    CGFloat y = height;
//    NSLog(@"111");
//    [UIView animateWithDuration:0.2 animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, - y + 160);
//    }];
//}
//- (void)keyboardWillHide:(NSNotification *)notification {
//    [UIView animateWithDuration:0.2 animations:^{
//        self.view.transform = CGAffineTransformIdentity;
//    }];
//}
- (void) setUI {
    
    self.view.backgroundColor = UIColor.greenColor;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(35, self.view.bounds.size.height / 3, 323, 530);
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.layer.cornerRadius = 30;
    self.scrollView.contentSize = CGSizeMake(323, self.view.bounds.size.height);
    self.scrollView.backgroundColor = UIColor.whiteColor;
    self.scrollView.userInteractionEnabled = NO;
    [self.view addSubview:_scrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"邮箱登陆";
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    self.titleLabel.tintColor = UIColor.greenColor;
    [_scrollView addSubview:_titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0).offset(60);
        make.width.equalTo(@200);
        make.height.equalTo(@70);
    }];
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.font = [UIFont systemFontOfSize:20];
    self.usernameField.placeholder = @"请输入用户名";
    self.usernameField.tag = 1;
    self.usernameField.keyboardType = UIKeyboardTypeDefault;
    self.usernameField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myPage.png"]];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    UIColor* myColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242 / 255.0 alpha:1];
    self.usernameField.backgroundColor = myColor;
    self.usernameField.delegate = self;
    [_scrollView addSubview:_usernameField];
    [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.width.equalTo(@240);
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
    self.passwordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiesuo.png"]];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.backgroundColor = myColor;
   
    self.passwordField.delegate = self;
    [_scrollView addSubview:_passwordField];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.usernameField.mas_bottom).offset(20);
        make.width.equalTo(@240);
        make.height.equalTo(@40);
    }];
    self.passwordField.layer.masksToBounds = YES;
    self.passwordField.layer.cornerRadius = 10;
//
    self.submmitButton.enabled = NO;
    self.submmitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    [_scrollView addSubview:_submmitButton];
    [_submmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.passwordField.mas_bottom).offset(40);
        make.width.equalTo(@240);
        make.height.equalTo(@50);
    }];
//
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.backgroundColor = buttonColor;
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.registerButton addTarget:self action:@selector(presentRegister) forControlEvents:UIControlEventTouchUpInside];
    //self.registerButton.frame = CGRectMake(200, 460, 80, 40);
    self.registerButton.tintColor = UIColor.whiteColor;
    self.registerButton.layer.cornerRadius = 20;
    [_scrollView addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.submmitButton.mas_bottom).offset(10);
        make.width.equalTo(@240);
        make.height.equalTo(@50);
    }];
//    [self.view addSubview:_submmitButton];
//    [self.view addSubview:_usernameField];
//    [self.view addSubview:_passwordField];
//    [self.view addSubview:_registerButton];
}
-(void)presentRegister {
    BJRegisterViewController* registerViewController = [[BJRegisterViewController alloc] init];
    [self presentViewController:registerViewController animated:YES completion:nil];
}
- (void)setupBindings {
    [self.viewModel addObserver:self forKeyPath:@"isValidLogin" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isValidLogin"]) {
        self.submmitButton.enabled = self.viewModel.isValidLogin;
        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _usernameField) {
        self.viewModel.user.email = textField.text;
    } else {
        self.viewModel.user.password = textField.text;
    }
}
- (void)showSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:^{
        [self.delegate changeTab];
    }];
}
- (void)showFailureAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"登陆失败，密码或邮箱错误" preferredStyle:UIAlertControllerStyleAlert];
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
- (void)dealloc {
    [self.viewModel removeObserver:self forKeyPath:@"isValidLogin"];
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
