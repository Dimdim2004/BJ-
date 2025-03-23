//
//  NSString+CalculateHeighti.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import <Foundation/Foundation.h>
@class UIFont;
NS_ASSUME_NONNULL_BEGIN

@interface NSString (CalculateHeight)
- (CGFloat) textHight:(NSString*)string andFont:(UIFont*)font Width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
