//
//  BJSearchBar.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/6.
//

#import "BJSearchBar.h"

@implementation BJSearchBar

<<<<<<< HEAD


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


=======
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 获取内部textField
    UITextField *searchField = [self valueForKey:@"searchField"];
    if(searchField) {
        UIFont *font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        searchField.font = font;
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        CGRect frame = searchField.frame;
        frame.size.height = 40.0;
        searchField.frame = frame;
        
        searchField.layer.cornerRadius = 20.0;
        searchField.clipsToBounds = YES;
        
    }
    
}

>>>>>>> temp-branch
@end
