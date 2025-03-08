//
//  BJSearchBar.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/6.
//

#import "BJSearchBar.h"

@implementation BJSearchBar



- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 找到内部的 UITextField
    UITextField *searchField = [self valueForKey:@"searchField"];
    
    // 设置圆角
    searchField.layer.cornerRadius = 20.0;
    searchField.clipsToBounds = YES;
    
    // 设置高度
    CGRect frame = searchField.frame;
    frame.size.height = 40.0;
    searchField.frame = frame;
    
    // 可选：设置背景色
    searchField.backgroundColor = [UIColor whiteColor];
    
}


@end
