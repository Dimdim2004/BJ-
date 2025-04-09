//
//  BJShopViewController.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/20.
//

#import "BJShopViewController.h"
#import "BJScaleTableViewCell.h"
#import "BJDetailViewController.h"
#import <Masonry.h>
#import "BJProductModel.h"


@interface BJShopViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic)UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray<BJDetailViewController *> *pageContentArray;
@end

@implementation BJShopViewController

- (void)viewDidLoad {
    NSArray *productData = @[
        @{
            @"name" : @"洛川苹果",
            @"location" : @"陕西省延安市洛川县",
            @"desc" : @"产自世界苹果最佳优生区渭北黄土高原，果形端庄、色泽鲜艳，口感香甜多汁，年产量占全国1/3。品牌价值达829亿元，位居全国水果类榜首，远销海内外",
            @"imageURL" : @"apple.png"
        },
        @{
            @"name": @"周至猕猴桃",
            @"location": @"陕西省西安市周至县",
            @"desc": @"全球每4个猕猴桃就有1个产自周至，果肉细嫩多汁，维生素C含量极高，被誉为“维生素C之王”。种植面积达87万亩，全产业链综合产值超200亿元",
            @"imageURL": @"nihoutao.png"
        },
        @{
            @"name" : @"佳县红枣",
            @"location" : @"陕西省榆林市佳县",
            @"desc" : @"黄河沿岸特产，果大核小、皮薄肉厚，含糖量高达70%。兼具补血养颜功效，年产量占陕北红枣主产区30%，是黄土高原标志性农产品",
            @"imageURL" : @"hongzao.png"
        },
        @{
            @"name" : @"紫阳富硒茶",
            @"location" : @"陕西省安康市紫阳县",
            @"desc" : @"中国最北端生态茶区特产，硒元素含量达0.25-3.5ppm。包含毛尖、翠峰等品类，汤色嫩绿明亮，年产值超40亿元，占陕南茶产业核心产值",
            @"imageURL" : @"cha.png"
        },
        @{
            @"name" : @"洋县黑米",
            @"location" : @"陕西省汉中市洋县",
            @"desc" : @"国家地理标志产品，外皮墨黑内芯雪白，富含硒元素及18种氨基酸。药食同源，具有滋阴补肾功效，种植历史可追溯至西汉时期",
            @"imageURL" : @"heimi.png"
        }
    ];

    NSArray<BJProductModel *> *productModels = [BJProductModel productsWithArray:productData];
    
    NSMutableArray *vcs = [NSMutableArray array];
    for (BJProductModel *model in productModels) {
        BJDetailViewController *vc = [[BJDetailViewController alloc] initWithModel:model];
        [vcs addObject:vc];
    }
    self.pageContentArray = [vcs copy];
    
    [super viewDidLoad];
    [self setupViews];
}

-(void)setupViews {
    

    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @20};
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:options];
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;

    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    self.pageVC.view.clipsToBounds = YES;
    self.pageVC.view.layer.cornerRadius = 20;
    
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@100);
        make.height.equalTo(@600);
        make.width.equalTo(@340);
    }];
    [self.pageVC setViewControllers:@[self.pageContentArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self.pageContentArray indexOfObject:viewController];
    if (currentIndex == 0) {
        return self.pageContentArray[self.pageContentArray.count - 1];
    } else if (currentIndex == NSNotFound) {
        return nil;
    }
    return self.pageContentArray[currentIndex - 1];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self.pageContentArray indexOfObject:viewController];
    if (currentIndex == self.pageContentArray.count - 1) {
        return self.pageContentArray[0];
    } else if (currentIndex == NSNotFound) {
        return nil;
    }
    return self.pageContentArray[currentIndex + 1];
}


@end
