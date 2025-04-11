//
//  BJLocationViewController.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/31.
//

#import <UIKit/UIKit.h>

@protocol BJSendBackProtocol <NSObject>

-(void)sendBackLocation:(NSString *)location;

@end

NS_ASSUME_NONNULL_BEGIN
@class BJLocationModel;
@interface BJLocationViewController : UIViewController
@property (strong, nonatomic)NSArray<BJLocationModel *> *models;
@property (weak, nonatomic) id<BJSendBackProtocol> delegate;
@end

NS_ASSUME_NONNULL_END
