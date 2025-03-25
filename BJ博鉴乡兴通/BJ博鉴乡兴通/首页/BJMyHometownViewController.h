//
//  BJMyHometownViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/8.
//

#import <UIKit/UIKit.h>
@class BJCountryModel,BJCommityModel;
NS_ASSUME_NONNULL_BEGIN

@interface BJMyHometownViewController : UIViewController
@property (strong, nonatomic)BJCountryModel *countryModel;
@property (strong, nonatomic)NSMutableArray <BJCommityModel *>* commityArray;

@end

NS_ASSUME_NONNULL_END
