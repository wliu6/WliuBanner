//
//  WliuBannerScrollView.m
//  WliuBanner
//
//  Created by 66 on 15/7/2.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#pragma mark - header files
#import "WliuBannerScrollView.h"
#import "WliuBannerMacroHeader.h"

NSString * const RHCTBannerPlaceholderImageURLString = @"com.Wliu.bannerPlaceholderImage";

@implementation WliuBannerScrollView

#pragma mark - Configure
- (void)bannerScrollViewBasicConfigureWithBannerWidth:(CGFloat)bannerWidth
{
    self.pagingEnabled = YES;
    
    self.bounces = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.contentSize = CGSizeMake(bannerWidth * 3, 0);
    
    self.contentOffset = CGPointMake(bannerWidth, 0);
}

- (void)subviewsConfigureWithBannerSize:(CGSize)bannerSize
{
    self.prefixImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
    [self defaultImageViewPropertiesWithImageView:self.prefixImageView];
    [self addSubview:self.prefixImageView];
    
    self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bannerSize.width, 0, bannerSize.width, bannerSize.height)];
    [self defaultImageViewPropertiesWithImageView:self.middleImageView];
    [self addSubview:self.middleImageView];
    
    self.subfixImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bannerSize.width * 2, 0, bannerSize.width, bannerSize.height)];
    [self defaultImageViewPropertiesWithImageView:self.subfixImageView];
    [self addSubview:self.subfixImageView];
}
- (void)defaultImageViewPropertiesWithImageView:(UIImageView *)targetImageView{
    if (targetImageView) {
        targetImageView.clipsToBounds = YES;
        targetImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}
#pragma mark - Initializes
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat bannerWidth = frame.size.width;
        [self bannerScrollViewBasicConfigureWithBannerWidth:bannerWidth];

        [self subviewsConfigureWithBannerSize:frame.size];
        
        self.isChanged = NO;
    }
    return self;
}

#pragma mark - Click
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch) {
        if (self.bannerScrollViewDelegate && [self.bannerScrollViewDelegate respondsToSelector:@selector(BannerIsClicked)]) {
            [self.bannerScrollViewDelegate BannerIsClicked];
        }
    }
}

#pragma mark - own method
- (void)bannerConfigurePlaceholderWithPlaceholderImage:(UIImage *)placeholder
{
    dispatch_main_sync_safe(^{
        __weak UIImageView *wprefixIV = self.prefixImageView;
        if (wprefixIV) {
            self.prefixImageView.image = placeholder;
        }
        
        __weak UIImageView *wmiddleIV = self.middleImageView;
        if (wmiddleIV) {
            self.middleImageView.image = placeholder;
        }
        
        __weak UIImageView *wsubfixIV = self.subfixImageView;
        if (wsubfixIV) {
            self.subfixImageView.image = placeholder;
        }
    })
}
- (void)bannerPrefixImageWithImage:(UIImage *)prefixImage
{
    dispatch_main_sync_safe(^{
        __weak UIImageView *wprefixIV = self.prefixImageView;
        if (wprefixIV) {
            self.prefixImageView.image = prefixImage;
        }
    })
}
- (void)bannerMiddleImageWithImage:(UIImage *)middleImage
{
    dispatch_main_sync_safe(^{
        __weak UIImageView *wmiddleIV = self.middleImageView;
        if (wmiddleIV) {
            self.middleImageView.image = middleImage;
        }
    })
}
- (void)bannerSubfixImageWithImage:(UIImage *)subfixImage
{
    dispatch_main_sync_safe(^{
        __weak UIImageView *wsubfixIV = self.subfixImageView;
        if (wsubfixIV) {
            self.subfixImageView.image = subfixImage;
        }
    })
}
@end
