//
//  SceneDelegate.h
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/9.
//

#import <UIKit/UIKit.h>
@protocol tabControllDelgate;
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate, tabControllDelgate>

@property (strong, nonatomic) UIWindow * window;

@end

