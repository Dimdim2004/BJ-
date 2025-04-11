//
//  BJDetailViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/4/7.
//

#import "BJDetailViewController.h"
#import <Masonry.h>
#import "BJProductModel.h"

@interface BJDetailViewController ()
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation BJDetailViewController

- (instancetype)initWithModel:(BJProductModel *)model {
    self = [super init];
    if (self) {
        [self viewDidLoad];
        self.productModel = model; // 先存储数据
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)setupView {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:65];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 1;
    [self.view addSubview:self.nameLabel];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:30];
    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.numberOfLines = 1;
    [self.view addSubview:self.locationLabel];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];

    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.descriptionLabel];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0
                                                        green:arc4random_uniform(255)/255.0
                                                         blue:arc4random_uniform(255)/255.0
                                                alpha:1.0];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@80);
        make.left.right.equalTo(self.view);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        make.left.right.equalTo(self.view);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@200);
        make.width.equalTo(@200);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.right.equalTo(self.view).inset(20);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

- (void)setProductModel:(BJProductModel *)productModel {
    NSLog(@"%@",self.nameLabel);
    self.nameLabel.text = productModel.name;
    self.descriptionLabel.text = productModel.desc;
    self.locationLabel.text = productModel.location;
    self.imageView.image = [UIImage imageNamed:productModel.imageURL];
    
    _productModel = productModel;
    [self.view layoutIfNeeded];
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
