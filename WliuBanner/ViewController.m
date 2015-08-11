//
//  ViewController.m
//  WliuBanner
//
//  Created by 66 on 15/7/2.
//  Copyright (c) 2015年 w66. All rights reserved.
//




#import "ViewController.h"
#import "WliuBannerView.h"

#import "WliuBanner.h"
#import <objc/runtime.h>
@interface ViewController () <WliuBannerDelegate>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WliuBanner *ban1 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://img4.duitang.com/uploads/blog/201404/07/20140407121119_5MLJk.jpeg"}];
    
    WliuBanner *ban2 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://data.bbs.manmankan.com/album/201205/22/195107xithxy8mfyx9xuyu.jpg"}];
    
    WliuBanner *ban3 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://imgsrc.baidu.com/forum/pic/item/7c1ed21b0ef41bd55fff3eb651da81cb38db3dc0.jpg"}];
    
    WliuBanner *ban4 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://ww2.sinaimg.cn/mw600/6b5b4c75tw1e3g1a3q4uyj.jpg"}];
    
    WliuBanner *ban5 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://c.hiphotos.baidu.com/zhidao/pic/item/b999a9014c086e063fd0f10900087bf40ad1cb7c.jpg"}];
    
    WliuBanner *ban6 = [[WliuBanner alloc] initWithBannerDic:@{@"image" : @"http://ftol.1377.com/uploads/allimg/130923/2-130923102940B8.jpg"}];
    
    WliuBannerView *bannerView = [[WliuBannerView alloc] initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 3)allBannerObjsArray:@[ban1, ban2, ban3, ban4, ban5, ban6] bannerClass:[WliuBanner class]  bannerImagePropertyName:@"bannerImageURLString" placeholderImages:@[[UIImage imageNamed:@"WliuAutoPlaceholder-1"], [UIImage imageNamed:@"WliuAutoPlaceholder-2"]] animationDuration:0.3f];
    
    bannerView.delegate = self;
//    bannerView.bannerPageIndicatorTintColor = [UIColor greenColor];
//    bannerView.bannerCurrentPageIndicatorTintColor = [UIColor redColor];
//    [bannerView configureBannerAnimationInterval:10 animationDuration:3];
    [self.view addSubview:bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fasdfadf:(UIStoryboardSegue *)segue {}

- (void)clickWithBannerObj:(id)bannerObj
{
    NSLog(@"%@", bannerObj);
//    WliuBanner *obj = (WliuBanner *)bannerObj;
}
@end
