//
//  BJNotFoundViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/3/25.
//

#import "BJNotFoundViewController.h"
#import "BJnetworkingManger.h"
#import <Masonry.h>
#import "BJPostCountryViewController.h"
#import "BJCountryModel.h"
@interface BJNotFoundViewController ()<UITextViewDelegate>

@end

@implementation BJNotFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未找到";
    UINavigationBarAppearance *appearance = [self.navigationController.navigationBar.standardAppearance copy];
    appearance.titleTextAttributes = @{
           NSForegroundColorAttributeName: [UIColor blackColor]
       };
    self.navigationController.navigationBar.standardAppearance = appearance;
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self setupViews];
}

-(void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notFound.png"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];

    
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.view addSubview:self.backButton];

    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    NSString *fullText = @"抱歉,您所处的村庄还未被我们发现，请 点击此处 进行创建乡村页面";
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange clickRange = [fullText rangeOfString:@"点击此处"]; [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:89/255.0 blue:45/255.0 alpha:1] range:clickRange];
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:clickRange];
    NSURL *collapseURL = [NSURL URLWithString:@"clickToCommit"];
    [attributedText addAttribute:NSLinkAttributeName value:collapseURL range:clickRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, attributedText.length)];
    
    self.descriptionTextView.attributedText = attributedText;
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(@400);
        make.top.equalTo(self.view).offset(58);
    }];
    
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(50);
        make.width.equalTo(@300);
        make.height.equalTo(@90);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if([URL.absoluteString isEqualToString:@"clickToCommit"]) {
        BJPostCountryViewController* commityViewController = [[BJPostCountryViewController alloc] initWithMaxCount:1 andHidden:YES];
        commityViewController.countryModel = self.model;
        commityViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:commityViewController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)leftButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
