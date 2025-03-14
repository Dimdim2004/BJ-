//
//  BJForgetPasswordViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/11.
//

#import <UIKit/UIKit.h>
#import "BJCheckEmailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJCheckEmailViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIButton* codeButton;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextField* registerAccountTextField;
@property (nonatomic, strong) UILabel* userErrorLabel;
@property (nonatomic, strong) BJCheckEmailViewModel* viewModel;
@end

NS_ASSUME_NONNULL_END
