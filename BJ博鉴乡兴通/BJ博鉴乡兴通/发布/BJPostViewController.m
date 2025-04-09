//
//  BJPostViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJPostViewController.h"
#import "BJPostView.h"
#import "BJPostTableViewCell.h"
#import "BJPostCommityViewController.h"
@interface BJPostViewController ()

@end

@implementation BJPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postView = [[BJPostView alloc] initWithFrame:self.view.bounds];
    self.postView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.postView];
    [self.postView.commityButton addTarget:self action:@selector(pushCommityPostViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.postView.backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void) pushCommityPostViewController {
    BJPostCommityViewController* commityViewController = [[BJPostCommityViewController alloc] init];
    commityViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:commityViewController animated:YES completion:nil];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
