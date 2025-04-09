//
//  BJNotFoundViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BJCountryModel;
@interface BJNotFoundViewController : UIViewController
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIButton *backButton;
@property (strong, nonatomic)UITextView *descriptionTextView;
@property (strong, nonatomic)BJCountryModel *model;
@end

NS_ASSUME_NONNULL_END
