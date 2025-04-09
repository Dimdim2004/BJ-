//
//  BJScrollViewTableViewCell.m
//  BJ博鉴乡兴通
//
//  Created by wjc on 2025/1/23.
//

#import "BJScrollViewTableViewCell.h"
#import "Masonry.h"
#import "SDWebImage.h"


@implementation BJScrollViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   if (self) {
       
       self.backgroundColor = [UIColor clearColor];
       [self setupScrollView];
       [self setupPageControl];
       _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
       NSRunLoop *loop = [NSRunLoop currentRunLoop];
       [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           NSArray *arr = @[@"1.png",@"2.png",@"3.png",@"4.png",@"5.png"];
           [self configureWithTopStories:arr];
       });
       
   }
   return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.width -= 20;
    [super setFrame:frame];
    
}

- (void)setupScrollView {
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    
   // 设置滚动视图
   self.scrollView = [[UIScrollView alloc] init];
   self.scrollView.pagingEnabled = YES;
   self.scrollView.scrollEnabled = YES;
   self.scrollView.delegate = self;
   self.scrollView.showsHorizontalScrollIndicator = NO;

   [self.contentView addSubview:self.scrollView];
   self.scrollView.frame = CGRectMake(0, 0, 393, 235);
    
   
}
- (void)setupPageControl {
   self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
   self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
   self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
  
   self.pageControl.currentPage = 0;
   self.pageControl.userInteractionEnabled = NO;
   
   [self.contentView addSubview:self.pageControl];
   
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(-10);
        make.right.equalTo(self.scrollView).offset(-10);
    }];
}

- (void)configureWithTopStories:(NSArray *)images {
    CGFloat width = 393;
    CGFloat height = 223;
    self.pageControl.numberOfPages = images.count;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *image;
    UIImageView *imageView;
    for (int i = 0; i < images.count + 2; i++) {

        if(i == 0) {
            image = images[images.count - 1];
        } else if (i == images.count + 1) {
            image = images[0];
        } else {
            image = images[i - 1];
        }
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(width * i, 0, width - 20, height);
        
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(width * (images.count + 2), height);
    
    self.pageControl.numberOfPages = images.count;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}

#pragma mark - 实现无限滚动视图

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   if ([_timer isValid]) {
       [_timer invalidate];
       _timer = nil;
   }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   if (![_timer isValid]) {
       _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
       NSRunLoop *loop = [NSRunLoop currentRunLoop];
       [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
   }
}

- (void)nextPage {
   NSInteger page = self.pageControl.currentPage;
   page++;
   CGFloat offsetX = (page + 1) * self.scrollView.frame.size.width; // 偏移量加1，因为第1页是假的
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   CGFloat offsetX = scrollView.contentOffset.x;
   CGFloat pageWidth = scrollView.frame.size.width;
   
   if (offsetX >= pageWidth * 6) {
       [self.scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
   } else if (offsetX <= 0) {
       [self.scrollView setContentOffset:CGPointMake(pageWidth * 5, 0) animated:NO];
   }
   
   // 更新UIPageControl的当前页
   NSInteger currentPage = (scrollView.contentOffset.x - pageWidth / 2) / pageWidth;
   self.pageControl.currentPage = currentPage;
    
    
}
@end
