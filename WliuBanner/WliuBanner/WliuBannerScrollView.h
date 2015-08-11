//
//  WliuBannerScrollView.h
//  WliuBanner
//
//  Created by 66 on 15/7/2.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const RHCTBannerPlaceholderImageURLString;

@protocol WliuBannerScrollViewDelegate <NSObject>

- (void)BannerIsClicked;

@end


@interface WliuBannerScrollView : UIScrollView

@property(nonatomic,strong) UIImageView *prefixImageView;

@property(nonatomic,strong) UIImageView *middleImageView;

@property(nonatomic,strong) UIImageView *subfixImageView;

@property(nonatomic,assign) id<WliuBannerScrollViewDelegate> bannerScrollViewDelegate;

- (void)bannerConfigurePlaceholderWithPlaceholderImage:(UIImage *)placeholder;

@property(nonatomic,assign) BOOL isChanged;

- (void)bannerPrefixImageWithImage:(UIImage *)prefixImage;
- (void)bannerMiddleImageWithImage:(UIImage *)middleImage;
- (void)bannerSubfixImageWithImage:(UIImage *)subfixImage;
@end
