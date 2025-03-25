//
//  BJCountryModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/23.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface BJCountryModel : NSObject<YYModel>
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *image;
@property (strong, nonatomic)NSString *countryID;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)NSString *countryDescription;
@property (assign, nonatomic)CGFloat longitude;
@property (assign, nonatomic)CGFloat latitude;

@end

NS_ASSUME_NONNULL_END
