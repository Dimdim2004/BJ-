//
//  BJCountryInfoTableViewCell.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/23.
//

#import <UIKit/UIKit.h>
@class BJCountryModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJCountryInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *nameLabel;
- (void)configureWithModel:(BJCountryModel *)model;
@end

NS_ASSUME_NONNULL_END
