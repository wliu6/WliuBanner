//
//  WliuBannerView.m
//  WliuBanner
//
//  Created by 66 on 15/7/2.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#pragma mark - headers
#import "WliuBannerView.h"
#import "WliuBannerScrollView.h"
#import "UIImageView+WliuImageLoad.h"
#import <objc/runtime.h>

//#define WliuDevloping

const CGFloat W66_ScrollMarginErrorSpace = 0.6f;

#pragma mark -- banner's page control place
const CGFloat W66_PageControlHeight = 10.0f;
const CGFloat W66_PageControlBottomSpace = 10.0f;

#pragma mark -- banner's page control's default pageIndicator tint color
#define W66_PageControlDefaultPageIndicatorTintColor  [UIColor grayColor]
#define W66_PageControlDefaultCurrentPageIndicatorTintColor  [UIColor whiteColor]

#pragma mark -- banner's action basic configure
const CGFloat W66_BannerTimerActionInterval = 3.0f;
const CGFloat W66_BannerTimerActionDuration = .33f;

#pragma mark -- banner's placeholder images' animation duration
const CGFloat W66_BannerPlaceholderAnimationDuration_Default = 0.2f;

@interface WliuBannerView ()<UIScrollViewDelegate, WliuBannerScrollViewDelegate>
{
@private
    WliuBannerScrollView *_bannerScrollView;
    
    UIPageControl *_bannerPageControl;
    
    NSArray *_currentBannerObjsArray;
    
    NSUInteger _currentBannerObjIndex;
    
    NSTimer *_bannerTimer;
    
    CGFloat _pageWidth;
    
    BOOL _scrollDelegateSafe;
    
    NSMutableArray *_bannerImagesArray;
    
    UIImage *_originPlaceholderImage;
    
    UIImage *_placeholderImage;
    
    NSArray *_placeholderImagesArray;
    
    CGFloat _placeholderAnimationDuration;
    
    NSString *_bannerImagePropertyName;
    
    Class _bannerClass;
    
    UIColor *_pageIndicatorTintColor;
    UIColor *_currentPageIndicatorTintColor;
    
    CGFloat _bannerAnimationDuration;
    CGFloat _bannerAnimationInterval;
}

@end

@implementation WliuBannerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#ifdef WliuDevloping
        NSParameterAssert(NO);// Please use the provided factory initialization
#endif
        [self basicConfigure:frame allBannerObjsArray:nil];
    }
    return self;
}
#pragma mark -- static placeholder
- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImage:(UIImage *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderImage = placeholder;
        [self bannerObjInfoConfigureWithImagePropertyName:bannerImagePropertyName bannerClass:bannerClass];
        [self basicConfigure:frame allBannerObjsArray:allBannerObjsArray];
    }
    return self;
}

#pragma mark --  dynamic placeholder
- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImages:(NSArray *)placeholders
{
    return [self initWithFrame:frame allBannerObjsArray:allBannerObjsArray bannerClass:bannerClass bannerImagePropertyName:bannerImagePropertyName placeholderImages:placeholders animationDuration:W66_BannerPlaceholderAnimationDuration_Default];
}

- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderImagesArray = placeholders;
        _placeholderAnimationDuration = animationDuration;
        [self bannerObjInfoConfigureWithImagePropertyName:bannerImagePropertyName bannerClass:bannerClass];
        [self basicConfigure:frame allBannerObjsArray:allBannerObjsArray];
    }
    return self;
}
#pragma mark - auxiliary initialize method
#pragma mark -- banner obj configure
- (void)bannerObjInfoConfigureWithImagePropertyName:(NSString *)bannerImagePropertyName bannerClass:(Class)bannerClass
{
    _bannerImagePropertyName = bannerImagePropertyName;
    _bannerClass = bannerClass;
#ifdef WliuDevloping
    NSParameterAssert([self bannerObjHasBannerProperty]);// bannerClass hasn't bannerProperty
#endif
}
#pragma mark -- banner objs arrays configure
- (void)basicConfigure:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray
{
    _currentBannerObjIndex = 0;
    
    [self initBannerObjsArrays];
    
    _pageIndicatorTintColor = W66_PageControlDefaultPageIndicatorTintColor;
    _currentPageIndicatorTintColor = W66_PageControlDefaultCurrentPageIndicatorTintColor;
    
    _pageWidth = frame.size.width;
    
    [self initBannerScrollViewWithFrame:frame];
    
    [self initBannerPageControlWithFrame:frame];
    
    if (allBannerObjsArray) {
        self.allBannerObjsArray = [allBannerObjsArray mutableCopy];
    }
    _scrollDelegateSafe = NO;
}
- (void)initBannerObjsArrays
{
    self.allBannerObjsArray = [[NSMutableArray alloc]init];
    _currentBannerObjsArray = [[NSArray alloc]init];
    _bannerImagesArray = [[NSMutableArray alloc]init];
}

#pragma mark -- init banner scroll
- (void)initBannerScrollViewWithFrame:(CGRect)frame
{
    _bannerScrollView = [[WliuBannerScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    if (_placeholderImage) {
        [_bannerScrollView bannerConfigurePlaceholderWithPlaceholderImage:_placeholderImage];
        _originPlaceholderImage = _placeholderImage;
    }
    
    if (_placeholderImagesArray) {
        UIImage *placeholderImage = [UIImage animatedImageWithImages:_placeholderImagesArray duration:_placeholderAnimationDuration];
        [_bannerScrollView bannerConfigurePlaceholderWithPlaceholderImage:placeholderImage];
        _originPlaceholderImage = placeholderImage;
    }
    
    _bannerScrollView.delegate = self;
    _bannerScrollView.bannerScrollViewDelegate = self;
    [self addSubview:_bannerScrollView];
}

#pragma mark -- init banner page control
- (void)initBannerPageControlWithFrame:(CGRect)frame
{
    _bannerPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - W66_PageControlBottomSpace - W66_PageControlHeight / 2, frame.size.width, W66_PageControlHeight)];
    _bannerPageControl.hidesForSinglePage = YES;
    
    _bannerPageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _bannerPageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;

    _bannerAnimationInterval = W66_BannerTimerActionInterval;
    _bannerAnimationDuration = W66_BannerTimerActionDuration;
    
    [self addSubview:_bannerPageControl];
}

#pragma mark -- banner timer
- (void)initBannerTimer
{
    _bannerTimer = [NSTimer scheduledTimerWithTimeInterval:_bannerAnimationInterval target:self selector:@selector(timerResponseMethod) userInfo:nil repeats:YES];
}
- (void)timerResponseMethod
{
    if (!_scrollDelegateSafe) {
        [UIView animateWithDuration:_bannerAnimationDuration animations:^{
            _scrollDelegateSafe = NO;
            _bannerScrollView.contentOffset = CGPointMake(_pageWidth * 2, 0);
        }completion:^(BOOL finished) {
            _currentBannerObjIndex ++;
            if (_currentBannerObjIndex >= self.allBannerObjsArray.count) {
                _currentBannerObjIndex = 0;
            }
            [self reloadBannerScrollView];
            _bannerScrollView.contentOffset = CGPointMake(_pageWidth, 0);
        }];
    }
}
- (void)bannerTimerCancel
{
    if (_bannerTimer.valid) {
        [_bannerTimer invalidate];
    }
}
- (void)bannerTimerStart
{
    if (!_bannerTimer.valid) {
        [self initBannerTimer];
    }
}
- (void)configureBannerAnimationInterval:(CGFloat)interval animationDuration:(CGFloat)duration
{
    if (!interval || !duration) return;
    if (duration != _bannerAnimationDuration || interval != _bannerAnimationInterval) {
        _bannerAnimationDuration = duration;
        _bannerAnimationInterval = interval;
        if (_bannerTimer) {
            [self bannerTimerCancel];
            [self bannerTimerStart];
        }
    }
}
#pragma mark - properties
- (void)setBannerPageIndicatorTintColor:(UIColor *)bannerPageIndicatorTintColor
{
    if (!bannerPageIndicatorTintColor) return;
    if (![bannerPageIndicatorTintColor isEqual:_pageIndicatorTintColor]) {
        _pageIndicatorTintColor = bannerPageIndicatorTintColor;
        if (_bannerPageControl) {
            _bannerPageControl.pageIndicatorTintColor = bannerPageIndicatorTintColor;
        }
    }
}
- (void)setBannerCurrentPageIndicatorTintColor:(UIColor *)bannerCurrentPageIndicatorTintColor
{
    if (!bannerCurrentPageIndicatorTintColor) return;
    if (![bannerCurrentPageIndicatorTintColor isEqual:_bannerCurrentPageIndicatorTintColor]) {
        _bannerCurrentPageIndicatorTintColor = bannerCurrentPageIndicatorTintColor;
        if (_bannerPageControl) {
            _bannerPageControl.currentPageIndicatorTintColor = bannerCurrentPageIndicatorTintColor;
        }
    }
}
-(void)setAllBannerObjsArray:(NSMutableArray *)allBannerObjsArray
{
    if (allBannerObjsArray.count > 1) {
        [self initBannerTimer];
        _bannerPageControl.numberOfPages = allBannerObjsArray.count;
        _bannerPageControl.currentPage = 0;
    }else{
        _bannerScrollView.scrollEnabled = NO;
    }
    
    for (id bannerObj in allBannerObjsArray) {
        
        UIImage *placeholderImage = [[UIImage alloc] init];
        if (_placeholderImage) {
            placeholderImage = _placeholderImage;
        }
        
        if (_placeholderImagesArray) {
            placeholderImage = [UIImage animatedImageWithImages:_placeholderImagesArray duration:_placeholderAnimationDuration];
        }
        [_bannerImagesArray addObject:placeholderImage];
        
        [self bannerConfigureImagesWithAllBannerObjsArray:allBannerObjsArray bannerObj:bannerObj placeholderImage:placeholderImage];
        
    }
    
    if (_allBannerObjsArray != allBannerObjsArray) {
        _allBannerObjsArray = allBannerObjsArray;
        [self reloadBannerScrollView];
        _bannerScrollView.isChanged = YES;
    }
}

#pragma mark - own method
- (BOOL)bannerObjHasBannerProperty
{
    BOOL result = NO;
    if (_bannerClass && _bannerImagePropertyName) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(_bannerClass, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyNameTemp = [NSString stringWithUTF8String:property_getName(property)];
            if ([propertyNameTemp isEqualToString:_bannerImagePropertyName]) {
                result = YES;
            }
        }
    }
    return result;
}

- (void)bannerConfigureImagesWithAllBannerObjsArray:(NSMutableArray *)allBannerObjsArray bannerObj:(id)bannerObj placeholderImage:(UIImage *)placeholderImage
{
    id obj = [bannerObj performSelector:NSSelectorFromString(_bannerImagePropertyName)];
    NSURL *targetURL = [[NSURL alloc] init];
    
    if ([obj isKindOfClass:[NSURL class]]) {
        targetURL = (NSURL *)obj;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        targetURL = [NSURL URLWithString:(NSString *)obj];
    }
    
    if (!targetURL) {
#ifdef WliuDevloping
        NSParameterAssert(NO);// the banner obj's property isn't a 'NSString' or 'NSURL' class
#endif
    }
    UIImageView *imageViewTemp = [[UIImageView alloc]init];
    [imageViewTemp w6_setImageWithURL:targetURL placeholderImage:placeholderImage completion:^(BOOL completion, UIImage *image) {
        if (image) {
            NSUInteger index = [allBannerObjsArray indexOfObject:bannerObj];
            [_bannerImagesArray replaceObjectAtIndex:index withObject:image];
            if (allBannerObjsArray.count == 1) {
                _bannerScrollView.scrollEnabled = NO;
                [self bannerTimerCancel];
                [_bannerScrollView bannerMiddleImageWithImage:image];
            }
            if (allBannerObjsArray.count > 1) {
                _bannerScrollView.scrollEnabled = YES;
                [self reloadBannerScrollView];
            }
        }
    }];
}
- (void)reloadPageControl
{
    _bannerPageControl.numberOfPages = self.allBannerObjsArray.count;
    _bannerPageControl.currentPage = _currentBannerObjIndex;
}
- (void)reloadBannerScrollView
{
    [self reloadPageControl];
    
    if (self.allBannerObjsArray.count == 0) {
        
    }else if (self.allBannerObjsArray.count == 1) {
        [_bannerScrollView bannerMiddleImageWithImage:_bannerImagesArray[0]];
    }else{
        NSUInteger previousPage = _currentBannerObjIndex - 1;
        if (previousPage >= self.allBannerObjsArray.count) {
            previousPage = self.allBannerObjsArray.count - 1;
        }
        [_bannerScrollView bannerPrefixImageWithImage:_bannerImagesArray[previousPage]];
        [_bannerScrollView bannerMiddleImageWithImage:_bannerImagesArray[_currentBannerObjIndex]];
        NSUInteger nextPage = _currentBannerObjIndex + 1;
        if (nextPage >= self.allBannerObjsArray.count) {
            nextPage = 0;
        }
        [_bannerScrollView bannerSubfixImageWithImage:_bannerImagesArray[nextPage]];
        
    }
}

#pragma mark - father class method
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    _scrollDelegateSafe = [super pointInside:point withEvent:event];
    if (_scrollDelegateSafe) {
        [self bannerTimerCancel];
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - W66_BannerTimerDelegate
- (void)BannerIsClicked
{
#warning The banner's clicked method is invalid when the number of array that member is banner's Obj is equal 0
    if (!self.allBannerObjsArray || !self.allBannerObjsArray.count) return;
    id banner = self.allBannerObjsArray[_currentBannerObjIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithBannerObj:)]) {

        [self.delegate clickWithBannerObj:banner];
    }
    if (_scrollDelegateSafe) {
        _scrollDelegateSafe = NO;
        if (_bannerImagesArray.count > 1) {
            if (!_bannerTimer.valid) {
                [self initBannerTimer];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollDelegateSafe) {
        if (scrollView.contentOffset.x <= W66_ScrollMarginErrorSpace) {
            _currentBannerObjIndex --;
            if (_currentBannerObjIndex >= self.allBannerObjsArray.count) {
                _currentBannerObjIndex = self.allBannerObjsArray.count - 1;
            }
            [self reloadBannerScrollView];
            _bannerScrollView.contentOffset = CGPointMake(_pageWidth, 0);
        }
        if (scrollView.contentOffset.x >= _pageWidth * 2 - W66_ScrollMarginErrorSpace)
        {
            _currentBannerObjIndex ++;
            if (_currentBannerObjIndex >= self.allBannerObjsArray.count) {
                _currentBannerObjIndex = 0;
            }
            [self reloadBannerScrollView];
            _bannerScrollView.contentOffset = CGPointMake(_pageWidth, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollDelegateSafe = NO;
    [self bannerTimerStart];
}

@end
