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
@interface BJLoginViewController ()

@end

@implementation BJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupBindings];
    self.viewModel = [[BJLoginViewModel alloc] init];
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
- (void) setUI {
    self.view.backgroundColor = UIColor.greenColor;
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.font = [UIFont systemFontOfSize:20];
    self.usernameField.frame = CGRectMake(80, 320, 240, 40);
    self.usernameField.placeholder = @"请输入用户名";
    self.usernameField.tag = 1;
    self.usernameField.keyboardType = UIKeyboardTypeDefault;
    self.usernameField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghu.png"]];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.backgroundColor = UIColor.whiteColor;
    self.usernameField.delegate = self;
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.font = [UIFont systemFontOfSize:20];
    self.passwordField.frame = CGRectMake(80, 380, 240, 40);
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.tag = 2;
    self.passwordField.placeholder = @"请输入密码";
    self.passwordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiesuo.png"]];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.backgroundColor = UIColor.whiteColor;
    self.passwordField.delegate = self;
    
    self.submmitButton.enabled = NO;
    self.submmitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submmitButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.submmitButton.layer.borderWidth = 2;
    [self.submmitButton setTitle:@"登陆" forState:UIControlStateNormal];
    self.submmitButton.tintColor = UIColor.whiteColor;
    self.submmitButton.frame = CGRectMake(100, 460, 80, 40);
    self.submmitButton.layer.cornerRadius = self.submmitButton.frame.size.width / 8;
    [self.submmitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth = 2;
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(presentRegister) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.frame = CGRectMake(200, 460, 80, 40);
    self.registerButton.tintColor = UIColor.whiteColor;
    self.registerButton.layer.cornerRadius = _registerButton.frame.size.width / 8;
    [self.view addSubview:_submmitButton];
    [self.view addSubview:_usernameField];
    [self.view addSubview:_passwordField];
    [self.view addSubview:_registerButton];
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
        self.viewModel.user.email = textField.text;
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
    [self.viewModel removeObserver:self forKeyPath:@"errorMessage"];
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
