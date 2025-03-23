//
//  SceneDelegate.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/9.
//

#import "SceneDelegate.h"
#import "BJHomePageViewController.h"
#import "BJShopViewController.h"
#import "BJPostViewController.h"
#import "BJCommunityViewController.h"
#import "BJMyPageViewController.h"
#import "BJLoginViewController.h"
#import "BJTabBarController.h"
#import "BJFindPasswordViewController.h"
#import "BJCheckEmailViewController.h"
#import "BJCheckEmailModel.h"
#import "BJFindPasswordSuccessModel.h"
#import "BJFindingPasswordViewModel.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    BJLoginViewController* rootViewController = [[BJLoginViewController alloc] init];
    rootViewController.delegate = self;
    self.window.rootViewController = rootViewController;
}
- (void)changeTab {
    // 创建 BJHomePageViewController 并设置相关属性
    BJHomePageViewController *homePageVC = [[BJHomePageViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    homePageVC.view.backgroundColor = [UIColor whiteColor];
    homePageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home.png"] tag:0];
    
    // 创建 BJShopViewController 并设置相关属性
    BJShopViewController *shopVC = [[BJShopViewController alloc] init];
    shopVC.view.backgroundColor = [UIColor whiteColor];
    shopVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"shop.png"] tag:1];
    
    // 创建 BJPostViewController 并设置相关属性
    BJCommunityViewController *communityVC = [[BJCommunityViewController alloc] init];
    UINavigationController* communityNavgationColler = [[UINavigationController alloc] initWithRootViewController:communityVC];
    communityVC.view.backgroundColor = [UIColor whiteColor];
    communityVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区" image:[UIImage imageNamed:@"community.png"] tag:2];
    
    // 创建 BJMyPageViewController 并设置相关属性
    
    BJMyPageViewController *myPageVC = [[BJMyPageViewController alloc] init];
    UINavigationController* postNavgationColler = [[UINavigationController alloc] initWithRootViewController:myPageVC];
    myPageVC.view.backgroundColor = [UIColor whiteColor];
    postNavgationColler.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"myPage.png"] tag:3];
    
    // 创建 UITabBarController 并添加视图控制器
    BJTabBarController *tabBarController = [[BJTabBarController alloc] init];
    tabBarController.viewControllers = @[nav1, shopVC, communityNavgationColler, postNavgationColler];
    tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    UITabBarAppearance *appearance = [UITabBarAppearance new];
    appearance.backgroundColor = [UIColor whiteColor];
    tabBarController.tabBar.standardAppearance = appearance;
    tabBarController.tabBar.scrollEdgeAppearance = appearance;
    
    // 将 tabBarController 设置为窗口的根视图控制器
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    UIOpenURLContext *urlContext = URLContexts.anyObject;
    if (urlContext) {
        NSURL *url = urlContext.URL;
        NSLog(@"App was opened by URL: %@", url.absoluteString);
        NSString* scheme = url.scheme;
        NSLog(@"%@", scheme);
        if ([scheme isEqualToString:@"countrytravel"]) {
            UIViewController *rootController = self.window.rootViewController;
            
            BJCheckEmailViewController* viewController = (BJCheckEmailViewController*)rootController.presentedViewController;
            BJFindPasswordViewController* presentViewController = [[BJFindPasswordViewController alloc] init];
            presentViewController.viewModel = [[BJFindingPasswordViewModel alloc] initWithAuthTyoe:1];
            presentViewController.viewModel.user.email = viewController.viewModel.user.email;
            NSLog(@"%@", presentViewController.viewModel.user.email);
            presentViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            NSLog(@"%@", [presentViewController class]);
            NSLog(@"%@", [rootController class]);
            [viewController presentViewController:presentViewController animated:YES completion:nil];
        }
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
