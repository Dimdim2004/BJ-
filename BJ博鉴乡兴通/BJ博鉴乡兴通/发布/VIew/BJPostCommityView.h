//
//  BJPostCommityView.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/9.
//

#import <UIKit/UIKit.h>
#import "BJPostTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface BJPostCommityView : UIView
@property (nonatomic, strong) UITableView* mainView;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* postButton;
@property (nonatomic, strong) UIButton* draftButton;
@property (nonatomic, strong) UIButton* previewButton;
@end

NS_ASSUME_NONNULL_END
