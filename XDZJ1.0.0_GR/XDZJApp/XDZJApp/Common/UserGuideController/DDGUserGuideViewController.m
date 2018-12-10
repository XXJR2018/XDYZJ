//
//  DDGUserGuideViewController.m
//  DDGProject
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "DDGUserGuideViewController.h"
#import "AppDelegate.h"

#define kNumberOfImage 3

@interface DDGUserGuideViewController ()

@property (nonatomic, strong) NSMutableArray *guideImagesArray;

@end

@implementation DDGUserGuideViewController


+ (NSArray *)guideImagesArray
{
    //不采用imageNamed:方式, 因为会缓存图片, 考虑这个图片比较大, 所以不做自动缓存
    NSMutableArray *guideImagesArray = [NSMutableArray arrayWithCapacity:kNumberOfImage];
    for (int i=1; i<=kNumberOfImage; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"guide_image_%d",i];
        UIImage *image = [UIImage imageNamedWithNoCache:imageName];
        if (image)
        {
            [guideImagesArray addObject:image];
        }
        
    }
    return guideImagesArray;
}

- (NSArray *)guideImagesArray{
    if (_guideImagesArray == nil){
        _guideImagesArray = [NSMutableArray arrayWithArray:[DDGUserGuideViewController guideImagesArray]];
    }
    return _guideImagesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSUInteger imageCount = self.guideImagesArray.count;
    
    if (imageCount == 0)
    {
        [self changeRootViewControllerButtonPressed:nil];
        return;
    }
    
    CGRect rect = self.view.bounds;
    
    //add the scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(imageCount * CGRectGetWidth(rect), CGRectGetHeight(rect));
    scrollView.bounces = NO;
    //insert the guide images into the scrollview
    for (NSUInteger i = 0; i < imageCount; i++)
    {
        UIImage *image = [self.guideImagesArray safeGetObjectAtIndex:i];
        rect.origin.x = i * CGRectGetWidth(rect);
        
        CGSize imageSize = image.size;
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 432, imageSize.height - 6, imageSize.width - 433);
        image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = rect;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:imageView];
    }
    
    rect.origin.y = SCREEN_HEIGHT - 85.f;
    rect.origin.x = 40 + (imageCount - 1) * SCREEN_WIDTH;
    rect.size = CGSizeMake(SCREEN_WIDTH - 40 * 2, 40);
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [ResourceManager redColor2];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.f;
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [button addTarget:self
               action:@selector(changeRootViewControllerButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    
    [self.view addSubview:scrollView];
}

#pragma mark -
#pragma mark ==== PrivateMethods ====
#pragma mark -

- (void)changeRootViewControllerButtonPressed:(id)sender
{
    //更新第一次启动信息
    [XXJRUtils saveBundleVersion];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    // update by baicai
    
    //[appDelegate getStartUpViewController];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
