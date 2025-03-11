//
//  BJPostCommityViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/9.
//

#import "BJPostCommityViewController.h"
#import "BJPostCommityView.h"
#import "BJPostTableViewCell.h"
#import "BJCommityPostLoactionTableViewCell.h"
@interface BJPostCommityViewController ()

@end

@implementation BJPostCommityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postView = [[BJPostCommityView alloc] initWithFrame:self.view.bounds];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"title"];
    [self.postView.mainView registerClass:[BJCommityPostLoactionTableViewCell class] forCellReuseIdentifier:@"loaction"];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"content"];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"image"];
    [self.view addSubview:self.postView];
    self.postView.mainView.delegate = self;
    self.postView.mainView.dataSource = self;
    [self.postView.backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 200;
    } else {
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJPostTableViewCell* titleCell = [tableView dequeueReusableCellWithIdentifier:@"title"];
    BJPostTableViewCell* contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    BJPostTableViewCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:@"image"];
    BJCommityPostLoactionTableViewCell* loactionCell = [tableView dequeueReusableCellWithIdentifier:@"loaction"];
    if (indexPath.section == 0) {
        [buttonCell.btn addTarget:self action:@selector(pushSelectImage) forControlEvents:UIControlEventTouchUpInside];
        return buttonCell;
    } else if (indexPath.section == 1) {
        return titleCell;
    } else if (indexPath.section == 2) {
        return contentCell;
    } else {
        
        return loactionCell;
    }
}
- (void)pushSelectImage {
    NSLog(@"推出选择照片的页面");
        //能选择的最大图片数
        NSInteger maxCount = 4;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.isSelectOriginalPhoto = NO;
        [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        }];
        // 修改 字体颜色为黑色
        [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingMultipleVideo = NO;// 是否可以多选视频
        // 设置是否显示图片序号
        imagePickerVc.showSelectedIndex = YES;
        //  照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        if (@available(iOS 13.0, *)) {
            imagePickerVc.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
        }
        // 你可以通过block或者代理，来得到用户选择的照片.
       
        [self presentViewController:imagePickerVc animated:YES completion:nil];
   
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
