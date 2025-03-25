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
#import "BJPreviewlViewController.h"
#import "BJCommityPostModel.h"
#import "BJPreviewModel.h"
#import "BJNetworkingManger.h"
#import "BJMyDraftModel.h"
#import "BJLocalDataManger.h"
#import "BJMymagesInDraftModel.h"
#import "BJNetworkingManger.h"
@interface BJPostCommityViewController () {
    UITapGestureRecognizer* _resTap;
}

@end

@implementation BJPostCommityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uploadPhotos = @[];
    self.model = [[BJCommityPostModel alloc] init];
    self.model.titleString = @"";
    self.model.contetnString = @"";
    self.postView = [[BJPostCommityView alloc] initWithFrame:self.view.bounds];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"title"];
    [self.postView.mainView registerClass:[BJCommityPostLoactionTableViewCell class] forCellReuseIdentifier:@"loaction"];
    [self.postView.mainView registerClass:[BJCommityPostLoactionTableViewCell class] forCellReuseIdentifier:@"friendRange"];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"content"];
    [self.postView.mainView registerClass:[BJPostTableViewCell class] forCellReuseIdentifier:@"image"];
    [self.view addSubview:self.postView];
    self.postView.mainView.delegate = self;
    self.postView.mainView.dataSource = self;
    [self.postView.backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.postView.postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    [self.postView.draftButton addTarget:self action:@selector(draft) forControlEvents:UIControlEventTouchUpInside];
    [self.postView.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    if (!_resTap) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardWillHide:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        _resTap = tapGesture;
    }
    if ([self.textView isFirstResponder]) {
        [self.textView addGestureRecognizer:_resTap];
    } else {
        [self.textField addGestureRecognizer:_resTap];
    }
}

- (void)keyboardWillHide:(UITapGestureRecognizer *)tap {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
        [self.textView removeGestureRecognizer:_resTap];
    } else {
        [self.textField resignFirstResponder];
        [self.textField removeGestureRecognizer:_resTap];
    }
    
}
- (void)tapClick {
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)post {
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:@"请输入内容"] ) {
        id manger = [BJNetworkingManger sharedManger];
        [manger uploadWithImage:self.uploadPhotos andTitle:self.textField.text Content:self.textView.text uploadSuccess:^(BJUploadSuccessModel * _Nonnull uploadModel) {
                [self showPostSuccessAlert];
            } error:^(NSError * _Nonnull error) {
                NSLog(@"上传失败");
            }];
    } else {
        NSLog(@"文字不能为空");
    }
    
}
- (void)draft {
    BJMyDraftModel* model = [[BJMyDraftModel alloc] init];
    BJMymagesInDraftModel* imagesModel = [[BJMymagesInDraftModel alloc] init];
    [[BJLocalDataManger sharedManger] loadDataManger:model];
    NSInteger noteId = 0;
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:@"请输入内容"]) {
        model.contentString = self.textView.text;
        model.titleString = self.textField.text;
        if ([BJNetworkingManger sharedManger].email != nil) {
            model.email = [BJNetworkingManger sharedManger].email;
        } else {
            model.email = @"3073623804@qq.com";
        }
        [[BJLocalDataManger sharedManger] insert:model];
        NSArray* ary = [[BJLocalDataManger sharedManger] search:model];
        model = ary[0];
        noteId = model.noteId;
        [[BJLocalDataManger sharedManger] closeCurrentDatabase];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray* ary = [self saveImages];
            BJMymagesInDraftModel* imagesModel = [[BJMymagesInDraftModel alloc] init];
            [[BJLocalDataManger sharedManger] loadDataManger:imagesModel];
            for (int i = 0; i < ary.count; i++) {
                BJMymagesInDraftModel* imagesModel = [[BJMymagesInDraftModel alloc] init];
                imagesModel.noteId = noteId;
                imagesModel.imageFilePath = ary[i];
                [[BJLocalDataManger sharedManger] insert:imagesModel];
            }
            [[BJLocalDataManger sharedManger] closeCurrentDatabase];
            [self showDraftSuccessAlert];
        });
    }
}

- (void)showDraftSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"保存到草稿箱成功" message:@"退出编辑发表页面" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showPostSuccessAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"退出编辑发表页面" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSArray*)saveImages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSMutableArray* ary = [NSMutableArray array];
    [self.uploadPhotos enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger index, BOOL *stop) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if (!data) {
            NSLog(@"第%lu张图片转换失败", (unsigned long)(index + 1));
            return;
        }
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        [dateFormatter setDateFormat:@"yyyyMMdd_HHmmssSSS.jpg"];
        NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
        NSString *randomSuffix = [NSString stringWithFormat:@"%04u", arc4random_uniform(10000)];
        NSString *fileName = [NSString stringWithFormat:@"image_%@_%@.jpg", timestamp, randomSuffix];
        NSURL *fileURL = [documentsURL URLByAppendingPathComponent:fileName];
        NSError *error = nil;
        BOOL success = [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
        [ary addObject:fileURL.absoluteString];
        if (success) {
            NSLog(@"第%lu张图片保存成功", (unsigned long)(index + 1));
        } else {
            NSLog(@"第%lu张图片保存失败: %@", (unsigned long)(index + 1), error.localizedDescription);
        }
    }];
    return [NSArray arrayWithArray:ary];
}
- (void)preview  {
    BJPreviewlViewController* preViewController = [[BJPreviewlViewController alloc] init];
    preViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    preViewController.photos = [self.uploadPhotos copy];
    preViewController.model = [[BJPreviewModel alloc] init];
    preViewController.model.titleString = self.model.titleString;
    preViewController.model.contetnString = self.model.contetnString;
    NSLog(@"%@", preViewController.photos);
    [self presentViewController:preViewController animated:YES completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        self.model.titleString = textField.text;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 200;
    } else {
        return 40;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        self.model.contetnString = @"";
        textView.textColor = UIColor.grayColor;
        textView.text = @"请输入内容";
    } else {
        self.model.contetnString = textView.text;
    }
   
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%@", textView.text);
    if ([textView.text isEqualToString:@"请输入内容"]) {
        textView.textColor = UIColor.blackColor;
        textView.text = @"";
    } else {
        return;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJPostTableViewCell* titleCell = [tableView dequeueReusableCellWithIdentifier:@"title"];
    BJPostTableViewCell* contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    BJPostTableViewCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:@"image"];
    BJCommityPostLoactionTableViewCell* loactionCell = [tableView dequeueReusableCellWithIdentifier:@"loaction"];
    BJCommityPostLoactionTableViewCell* friendCell = [tableView dequeueReusableCellWithIdentifier:@"friendRange"];
    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    loactionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    friendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [buttonCell.btn addTarget:self action:@selector(pushSelectImage) forControlEvents:UIControlEventTouchUpInside];
        [buttonCell addPhotosAry:self.uploadPhotos];
        return buttonCell ;
    } else if (indexPath.section == 1) {
        titleCell.titleView.text = self.model.titleString.length == 0 ? @"" : self.model.titleString;
        titleCell.titleView.delegate = self;
        titleCell.titleView.tag = 100;
        _textField = titleCell.titleView;
        return titleCell;
    } else if (indexPath.section == 2) {
        contentCell.contentTextView.text = self.model.contetnString.length == 0 ? @"请输入内容" : self.model.contetnString;
        contentCell.contentTextView.delegate = self;
        contentCell.contentTextView.textColor =  self.model.contetnString.length == 0 ? UIColor.lightGrayColor : UIColor.blackColor;
        _textView = contentCell.contentTextView;
        return contentCell;
    } else if (indexPath.section == 3) {
        return loactionCell;
    } else {
        return friendCell;
    }
}
- (void)pushSelectImage {
    NSLog(@"推出选择照片的页面");
        //能选择的最大图片数
        NSInteger maxCount = 9;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.isSelectOriginalPhoto = NO;
        [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        }];
        [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingMultipleVideo = NO;// 是否可以多选视频
        imagePickerVc.showSelectedIndex = YES;
        imagePickerVc.sortAscendingByModificationDate = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        if (@available(iOS 13.0, *)) {
            imagePickerVc.statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
        }
        // 你可以通过block或者代理，来得到用户选择的照片.
    __weak id weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.uploadPhotos = [photos copy];
        [self.postView.mainView reloadData];
    }];
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
