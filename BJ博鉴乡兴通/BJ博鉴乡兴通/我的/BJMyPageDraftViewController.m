//
//  BJMyPageDraftViewController.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/4/2.
//

#import "BJMyPageDraftViewController.h"
#import "BJPostCommityViewController.h"
#import "BJMainCommunityView.h"
#import "BJCommityCollectionViewCell.h"
#import "BJMyDraftModel.h"
#import "BJLocalDataManger.h"
#import "BJCommityPostModel.h"
#import "BJMyPageDraftModel.h"
#import "BJNetworkingManger.h"
#import "SDWebImage/SDWebImage.h"
#import "NSString+CalculateHeight.h"
@interface BJMyPageDraftViewController ()

@end

@implementation BJMyPageDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromTable];
    UIColor* mycolor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.view.backgroundColor = mycolor;
    self.iView = [[BJMainCommunityView alloc] initWithFrame:CGRectMake(0, 90, 393, self.view.frame.size.height)];
    [self.view addSubview:self.iView];
    
    [self regiserCollectionView];
    [self setTitleLabelAndButton];
    
    // Do any additional setup after loading the view.
}
- (void)setTitleLabelAndButton {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 393, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.text = @"草稿箱";
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 50, 30, 30);
    [self.view addSubview:button];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)regiserCollectionView {
    [self.iView setUIWithHeightAry:self.heightAry andSectionCount:1 itemCount:self.model.count];
    UIColor* mycolor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.iView.backgroundColor = mycolor;
    [self.iView.mainView registerClass:[BJCommityCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.iView.mainView.delegate = self;
    self.iView.mainView.dataSource = self;
    
}
- (void)loadDataFromTable {
    self.heightAry = [NSMutableArray array];
    self.imageAry = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    //NSURL *fileURL = [documentsURL URLByAppendingPathComponent:fileName];
    NSString* email = [BJNetworkingManger sharedManger].email;
    BJMyPageDraftModel* draftModel = [[BJMyPageDraftModel alloc] init];
    [[BJLocalDataManger sharedManger] loadDataManger:draftModel];
    self.model = [[BJLocalDataManger sharedManger] search:draftModel WithEmail:email];
    
    for (int i = 0; i < self.model.count; i++) {
        draftModel = self.model[i];
        NSLog(@"%@", draftModel.images[0]);
        NSURL *fileURL = [documentsURL URLByAppendingPathComponent:draftModel.images[0]];
        NSLog(@"%@", fileURL);
        [self.imageAry addObject:[UIImage imageWithContentsOfFile:fileURL.path]];
        [self.heightAry addObject: @([self loadHeight:self.imageAry[0] andString:draftModel.titleString])];
    }
    
    NSLog(@"%@", draftModel.titleString);
    NSLog(@"%@", draftModel.contentString);
    NSLog(@"%ld", draftModel.images.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BJCommityCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 3;
    cell.layer.borderWidth = 0.3;
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    BJMyPageDraftModel* draftModel = self.model[indexPath.item];
    cell.label.text = draftModel.titleString;
    cell.nameLabel.text = [BJNetworkingManger sharedManger].username;
    [cell.profileView sd_setImageWithURL:[BJNetworkingManger sharedManger].avatar];
    NSArray* ary = draftModel.images;
    [cell.likeButton setImage:[UIImage imageNamed:@"lajitong.png"] forState:UIControlStateNormal];
    [cell.likeButton addTarget:self action:@selector(deleteDraft:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageView.image = self.imageAry[indexPath.item];
    cell.contentView.backgroundColor = UIColor.whiteColor;
    
    
    return cell;
}
- (void)deleteDraft:(UIButton*)button {
    BJCommityCollectionViewCell* cell = (BJCommityCollectionViewCell*)button.superview.superview;
    NSIndexPath* indexPath = [self.iView.mainView indexPathForCell:cell];
    BJMyPageDraftModel* iModel = self.model[indexPath.item];
    [[BJLocalDataManger sharedManger] loadDataManger:[[BJMyPageDraftModel alloc] init]];
    NSLog(@"%ld", iModel.noteId);
    [[BJLocalDataManger sharedManger] deleteDarftData:iModel withKeyValue:iModel.noteId];
    NSMutableArray* ary = [NSMutableArray arrayWithArray:self.model];
    [ary removeObject:iModel];
    self.model = [ary copy];
    [UIView setAnimationsEnabled:NO];
    [self.iView.mainView performBatchUpdates:^{
        [self.iView.mainView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}
- (CGFloat)loadHeight:(UIImage*)image andString:(NSString*)text {
    CGFloat imageHeight = image.size.height / image.size.width * 186.5;
    CGFloat textHeight = [text textHight:text andFont:[UIFont systemFontOfSize:17] Width:186.5];
    NSLog(@"计算得出的一个高度%lf", imageHeight + textHeight + 55);
    return imageHeight + textHeight + 55;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"当前的一个item个数%ld", self.model.count);
    return self.model.count;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BJPostCommityViewController* commityViewController = [[BJPostCommityViewController alloc] init];
    commityViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    BJMyPageDraftModel* draModel = self.model[indexPath.item];
    NSMutableArray* uploadImageAry = [@[] mutableCopy];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    for (int i = 0; i < draModel.images.count; i++) {
        NSURL *fileURL = [documentsURL URLByAppendingPathComponent:draModel.images[i]];
        [uploadImageAry addObject:[UIImage imageWithContentsOfFile:fileURL.path]];
    }
    commityViewController.uploadPhotos = [uploadImageAry copy];
    commityViewController.model = [[BJCommityPostModel alloc] init];
    commityViewController.model.titleString = draModel.titleString;
    commityViewController.model.contetnString = draModel.contentString;
    commityViewController.type = 1;
    commityViewController.currentNoteId = draModel.noteId;
    [self presentViewController:commityViewController animated:YES completion:nil];
    
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
