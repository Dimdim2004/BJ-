//
//  BJPostCommityViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/9.
//

#import <UIKit/UIKit.h>
@class  BJPostCommityView;
#import "TZImagePickerController.h"
@class BJCommityPostModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJPostCommityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) BJPostCommityView* postView;
@property (nonatomic, copy) NSArray* uploadPhotos;
@property (nonatomic, strong) BJCommityPostModel* model;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UITextView* textView;
@end

NS_ASSUME_NONNULL_END
