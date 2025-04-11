//
//  BJMyHometownViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import <UIKit/UIKit.h>
@class BJCountryModel,BJCommityModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyHometownViewController : UIViewController<UITableViewDelegate>
@property (strong, nonatomic)BJCountryModel *countryModel;
@property (strong, nonatomic)NSMutableArray <BJCommityModel *>* commityArray;
@property(strong, nonatomic) UIImageView *headerImageView;
@end

NS_ASSUME_NONNULL_END
