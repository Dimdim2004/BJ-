//
//  NSString+CalculateHeighti.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import "NSString+CalculateHeight.h"
#import "UIKit/UIKit.h"
@implementation NSString (CalculateHeight)
- (CGFloat) textHight:(NSString*)string andFont:(UIFont*)font Width:(CGFloat)width {
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    CGFloat twoLineHeight = [self LineHeight:font Width:width];
    
    if (twoLineHeight > textRect.size.height && textRect.size.height > 20) {
        NSLog(@"1%@", string);
        NSLog(@"%lf", twoLineHeight);
        NSLog(@"%lf", textRect.size.height);
        return ceil(textRect.size.height);
    } else if (textRect.size.height < 20) {
        NSLog(@"2%@", string);
        NSLog(@"%lf", textRect.size.height);
        return 20;
    } else {
        NSLog(@"3%@", string);
        NSLog(@"%lf", textRect.size.height);
        return ceil(twoLineHeight);
    }
}

- (CGFloat) LineHeight:(UIFont*)font Width:(CGFloat)width {
    NSString* textString = @"实例文本\n实例文本";
    CGRect textRect = [textString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    CGFloat fixedTextHeight = ceil(CGRectGetHeight(textRect));
    return fixedTextHeight;
}
@end
