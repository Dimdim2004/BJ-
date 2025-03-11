//
//  BJPostCommityViewController.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/9.
//

#import "ViewController.h"
@class  BJPostCommityView;
#import "TZImagePickerController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJPostCommityViewController : ViewController <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) BJPostCommityView* postView;
@end

NS_ASSUME_NONNULL_END
