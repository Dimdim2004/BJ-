//
//  BJLocationModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/1.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface BJLocationModel : NSObject<YYModel>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *countryID;

@end

NS_ASSUME_NONNULL_END
