//
//  BJDisplayModel.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface BJDisplayModel : NSObject

@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *distance;
- (instancetype)initWithName:(NSString *)name distance:(NSString *)distance imageUrl:(NSString *)urlString;

- (void)loadImageWithCompletion:(void (^)(UIImage * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
