//
//  BJTabBarController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJTabBarController.h"
#import "BJTabBar.h"

@interface BJTabBarController ()

@end

@implementation BJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BJTabBar *customTabBar = [[BJTabBar alloc] init];
    [self setValue:customTabBar forKey:@"tabBar"];
    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
