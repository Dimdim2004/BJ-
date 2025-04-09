//
//  BJPostCountryViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/26.
//

#import "BJPostCountryViewController.h"
#import "BJNetworkingManger.h"
#import "BJCountryModel.h"
#import "BJMyHometownViewController.h"

@interface BJPostCountryViewController ()

@end

@implementation BJPostCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.text = self.countryModel.name;
}

-(NSString *)placeholderForFirstText {
    return @"请输入乡村名称";
}
-(NSString *)placeholderForSecondText {
    return @"请输入乡村简介";
}

- (NSString *)placeholderForButtonText {
    return @"上传村庄内容";
}

- (void)post:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.alpha = 1;
        sender.transform = CGAffineTransformIdentity;
    }];
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:[self placeholderForSecondText]] ) {
        BJNetworkingManger *manager = [BJNetworkingManger sharedManger];
        NSDictionary* params = @{@"name":self.textField.text, @"description":self.textView.text,@"image":[self.uploadPhotos firstObject],@"lon":@(self.countryModel.longitude), @"lat": @(self.countryModel.latitude),@"location":self.countryModel.location};
        [manager uploadWithParams:params uploadSuccess:^(NSString * _Nonnull countryIDString) {
            self.countryModel.countryID = countryIDString;
            [self showPostSuccessAlert];
            
        } error:^(NSError * _Nonnull error) {
            NSLog(@"上传失败");
        }];
    } else {
        [self showPostFailAlert];
    }
}

- (void)showPostSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"退出编辑发表页面" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [[BJNetworkingManger sharedManger] loadCountryInfoWithCountryID:self.countryModel.countryID WithSuccess:^(BJCountryModel * _Nonnull countryModel) {
            BJMyHometownViewController *hometownVC = [[BJMyHometownViewController alloc] init];
            hometownVC.countryModel = countryModel;
            NSLog(@"推出");
            [self.navigationController pushViewController:hometownVC animated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"加载失败");
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showPostFailAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布失败" message:@"请将发布内容填写完整" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
