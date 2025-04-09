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
#import "BJMyPageDraftModel.h"
#import "BJLocationViewController.h"

@interface BJPostCommityViewController ()<BJSendBackProtocol>
{
    UITapGestureRecognizer* _resTap;
    NSInteger _maxCount;
    BOOL _hidden;
}

@end

@implementation BJPostCommityViewController

- (instancetype)initWithMaxCount:(NSInteger)maxCount andHidden:(BOOL)hidden {
    self = [super init];
    if (self) {
        _maxCount = maxCount;
        _hidden = hidden;
    }
    return self;
}


- (NSString *)placeholderForFirstText {
    return @"请输入标题";
}

- (NSString *)placeholderForSecondText {
    return @"请输入内容";
}

- (NSString *)placeholderForButtonText {
    return @"发布内容";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.uploadPhotos == nil) {
        self.uploadPhotos = @[];
    }
    if (self.model == nil) {
        self.model = [[BJCommityPostModel alloc] init];
    }
    
    if (self.model.titleString == nil) {
        self.model.titleString = @"";
    }
    if (self.model.contentString == nil) {
        self.model.contentString = @"";
    }
    
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
    self.postView.backButton.hidden = YES;
    [self.postView.postButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    [self.postView.postButton setTitle:[self placeholderForButtonText] forState:UIControlStateNormal];
    if (self.type != 1) {
        [self.postView.draftButton addTarget:self action:@selector(draft) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.postView.draftButton.hidden = YES;
    }
    
    [self.postView.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
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
    if (self.type == 1) {
        [self showSaveAlert];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateDataBase {
    BJMyPageDraftModel* model = [[BJMyPageDraftModel alloc] init];
    model.noteId = _currentNoteId;
    //BJMymagesInDraftModel* imagesModel = [[BJMymagesInDraftModel alloc] init];
    [[BJLocalDataManger sharedManger] loadDataManger:model];
    NSArray* ary = [[BJLocalDataManger sharedManger] search:model];
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:@"请输入内容"]) {
        model.contentString = self.textView.text;
        model.titleString = self.textField.text;
        NSLog(@"%@", [BJNetworkingManger sharedManger].email);
        if ([BJNetworkingManger sharedManger].email != nil) {
            model.email = [BJNetworkingManger sharedManger].email;
           
        } else {
            model.email = @"3073623804@qq.com";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray* ary = [self saveImages];
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < ary.count; i++) {
                [array addObject: ary[i]];
            }
            model.images = [NSArray arrayWithArray:array];
            
            NSLog(@"查询当前的数组情况%@", [[BJLocalDataManger sharedManger] search:model]);
            [[BJLocalDataManger sharedManger] updateDraft:model withKeyValue:model.noteId];
            [[BJLocalDataManger sharedManger] closeCurrentDatabase];
            
            [self showDraftSuccessAlert];
        });
    }
}
- (void)showSaveAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"是否要保存更改" message:@"退出编辑发表页面" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateDataBase];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (void)post:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.alpha = 1;
        sender.transform = CGAffineTransformIdentity;
    }];
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:[self placeholderForSecondText]] ) {
        id manger = [BJNetworkingManger sharedManger];
        [manger uploadWithImage:self.uploadPhotos andTitle:self.textField.text Content:self.textView.text uploadSuccess:^(BJUploadSuccessModel * _Nonnull uploadModel) {
                [self showPostSuccessAlert];
            } error:^(NSError * _Nonnull error) {
                NSLog(@"上传失败");
            }];
    } else {
        NSLog(@"文字不能为空");
        [self showPostFailAlert];
    }
    
}
-(void)draft:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.alpha = 1;
    }];
    BJMyPageDraftModel* model = [[BJMyPageDraftModel alloc] init];
    [[BJLocalDataManger sharedManger] loadDataManger:model];
    if (self.textField.text.length > 0 && self.textView.text.length > 0 && ![self.textView.text isEqualToString:[self placeholderForSecondText]]) {
        model.contentString = self.textView.text;
        model.titleString = self.textField.text;
        if ([BJNetworkingManger sharedManger].email != nil) {
            model.email = [BJNetworkingManger sharedManger].email;
        } else {
            model.email = @"3073623804@qq.com";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray* ary = [self saveImages];
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < ary.count; i++) {
                [array addObject: ary[i]];
            }
            model.images = [NSArray arrayWithArray:array];
            [[BJLocalDataManger sharedManger] insert:model];
            NSLog(@"查询当前的数组情况%@", [[BJLocalDataManger sharedManger] search:model]);
            
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

- (void)showPostFailAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"发布失败" message:@"请将发布内容填写完整" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
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
        [dateFormatter setDateFormat:@"yyyyMMdd_HHmmssSSS"];
        NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
        NSString *randomSuffix = [NSString stringWithFormat:@"%04u", arc4random_uniform(10000)];
        NSString *fileName = [NSString stringWithFormat:@"image_%@_%@.jpg", timestamp, randomSuffix];
        NSURL *fileURL = [documentsURL URLByAppendingPathComponent:fileName];
        NSError *error = nil;
        BOOL success = [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
        [ary addObject:fileName];
        if (success) {
            NSLog(@"第%lu张图片保存成功", (unsigned long)(index + 1));
        } else {
            NSLog(@"第%lu张图片保存失败: %@", (unsigned long)(index + 1), error.localizedDescription);
        }
    }];
    return [NSArray arrayWithArray:ary];
}
- (void)preview {
    BJPreviewlViewController* preViewController = [[BJPreviewlViewController alloc] init];
    preViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    preViewController.photos = [self.uploadPhotos copy];
    preViewController.model = [[BJPreviewModel alloc] init];
    preViewController.model.titleString = self.model.titleString;
    preViewController.model.contetnString = self.model.contentString;
    [self presentViewController:preViewController animated:YES completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        self.model.titleString = textField.text;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _hidden ? 3 : 5;
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
        self.model.contentString = @"";
        textView.textColor = UIColor.grayColor;
        textView.text = [self placeholderForSecondText];
    } else {
        self.model.contentString = textView.text;
    }
   
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"%@", textView.text);
    if ([textView.text isEqualToString:[self placeholderForSecondText]]) {
        textView.textColor = UIColor.blackColor;
        textView.text = @"";
    } else {
        return;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BJPostTableViewCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:@"image"];
        buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buttonCell.btn addTarget:self action:@selector(pushSelectImage) forControlEvents:UIControlEventTouchUpInside];
        buttonCell.backgroundColor = [UIColor whiteColor];
        [buttonCell addPhotosAry:self.uploadPhotos];
        
        return buttonCell ;
    } else if (indexPath.section == 1) {
        BJPostTableViewCell* titleCell = [tableView dequeueReusableCellWithIdentifier:@"title"];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_hidden) {
            titleCell.titleView.text = self.model.titleString.length == 0 ? @"" : self.model.titleString;
        }
        
        titleCell.titleView.delegate = self;
        titleCell.titleView.tag = 100;
        _textField = titleCell.titleView;
        titleCell.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = [self placeholderForFirstText];
        return titleCell;
    } else if (indexPath.section == 2) {
        BJPostTableViewCell* contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contentCell.contentTextView.text = self.model.contentString.length == 0 ? [self placeholderForSecondText] : self.model.contentString;
        contentCell.contentTextView.delegate = self;
        contentCell.backgroundColor = [UIColor whiteColor];
        contentCell.contentTextView.textColor =  self.model.contentString.length == 0 ? UIColor.lightGrayColor : UIColor.blackColor;
        _textView = contentCell.contentTextView;
        return contentCell;
    } else if (indexPath.section == 3) {
        BJCommityPostLoactionTableViewCell* loactionCell = [tableView dequeueReusableCellWithIdentifier:@"loaction"];
        loactionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        loactionCell.backgroundColor = [UIColor whiteColor];
        loactionCell.hidden = _hidden;
        return loactionCell;
    } else {
        BJCommityPostLoactionTableViewCell* friendCell = [tableView dequeueReusableCellWithIdentifier:@"friendRange"];
        friendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        friendCell.backgroundColor = [UIColor whiteColor];
        friendCell.hidden = _hidden;
        return friendCell;
    }
}


- (void)pushSelectImage {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
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
    __weak id weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __strong BJPostCommityViewController *strongSelf = weakSelf;
        strongSelf.uploadPhotos = [photos copy];
        [strongSelf.postView.mainView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [[BJNetworkingManger sharedManger] loadAllCountryIDWithSuccess:^(NSArray<BJLocationModel *> * _Nonnull locationModel) {
            BJLocationViewController *locationVC = [[BJLocationViewController alloc] init];
            locationVC.models = locationModel;
            locationVC.delegate = self;
            [self presentViewController:locationVC animated:YES completion:nil];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
        
    }
}

- (void)sendBackCountryID:(NSString *)countryID {
    
}
@end
