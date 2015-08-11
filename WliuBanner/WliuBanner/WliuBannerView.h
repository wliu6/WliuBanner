//
//  WliuBannerView.h
//  WliuBanner
//
//  Created by 66 on 15/7/2.
//  Copyright (c) 2015年 w66. All rights reserved.
//
/*   
    Copyright (c) 2015 Six Wang
 
    For the full copyright and license information, please view
    the LICENSE file that was distributed with this source code.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
 
 1) Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
 
 2) Redistributions in binary form must reproduce the above  
      copyright notice, this list of conditions and the following 
      disclaimer in the documentation and/or other materials provided
      with the distribution.
 *
 */



#import <UIKit/UIKit.h>
#import "WliuBanner.h"

@protocol WliuBannerDelegate <NSObject>

@optional
/**/
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  This method that ' WliuBannerView ' response when click the banner view
 *
 *  @param bannerObj The banner Obj,
 *
 *  @since version number 1.0
 */
- (void)clickWithBannerObj:(id)bannerObj;
@end
@interface WliuBannerView : UIView

/*!
*  @author 66, 15-07-16
*
*  @brief  all banner objs array
*
*  @since version number 1.0
*/
@property(nonatomic, readonly,strong) NSMutableArray *allBannerObjsArray;
/*!
 *  @author 66, 15-07-16
 *
 *  @brief  banner delegate
 *
 *  @since version number 1.0
 */
@property(nonatomic,assign) id<WliuBannerDelegate> delegate;
#pragma mark - init
#pragma mark -- static placeholder
/*!
 *  @author 66, 15-07-16
 *
 *  @brief  Initializes and returns a newly allocated banner view object with static placeholder.
 *
 *  @param frame                   The frame rectangle for the view, measured in points
 *  @param allBannerObjsArray      banner object array
 *  @param bannerClass             The Class of banner
 *  @param bannerImagePropertyName the banner's property name that will request web resource.
 *  @param placeholder             placeholder image
 *
 *  @return banner view obj
 *
 *  @since version number 1.0
 */
- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImage:(UIImage *)placeholder;

#pragma mark --  dynamic placeholder
/*!
 *  @author 66, 15-07-16
 *
 *  @brief  Initializes and returns a newly allocated banner view object with dynamic placeholder,default animation duration
 *
 *  @param frame                   The frame rectangle for the view, measured in points
 *  @param allBannerObjsArray      banner object array
 *  @param bannerClass             The Class of banner
 *  @param bannerImagePropertyName the banner's property name that will request web resource.
 *  @param placeholders            placeholder images' array
 *
 *  @return banner view obj
 *
 *  @since version number 1.0
 */
- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImages:(NSArray *)placeholders;

/*!
 *  @author 66, 15-07-16
 *
 *  @brief  Initializes and returns a newly allocated banner view object with dynamic placeholder,custom animation duration
 *
 *  @param frame                   The frame rectangle for the view, measured in points
 *  @param allBannerObjsArray      The banner object's array
 *  @param bannerClass             The Class of banner
 *  @param bannerImagePropertyName The banner's property name that will request web resource.
 *  @param placeholders            placeholder images' array
 *  @param animationDuration       placeholder animation duration
 *
 *  @return banner view obj
 *
 *  @since version number 1.0
 */
- (instancetype)initWithFrame:(CGRect)frame allBannerObjsArray:(NSArray *)allBannerObjsArray bannerClass:(Class)bannerClass bannerImagePropertyName:(NSString *)bannerImagePropertyName placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration;

#pragma mark - banner timer control
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  banner timer start the time
 *
 *  @since version number 1.0
 */
- (void)bannerTimerStart;
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  banner timer end of the time
 *
 *  @since version number 1.0
 */
- (void)bannerTimerCancel;
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  Configure with banner animated execution time and interval
 *
 *  @param interval banner animated interval
 *  @param duration banner animated duration
 *
 *  @since version number 1.0
 */
- (void)configureBannerAnimationInterval:(CGFloat)interval animationDuration:(CGFloat)duration;
#pragma mark - banner page control tint color
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  The tint color to be used for the banner's page indicator.
 *
 *  @since version number 1.0
 */
@property(nonatomic,strong) UIColor *bannerPageIndicatorTintColor;
/*!
 *  @author 66, 15-08-11
 *
 *  @brief  The tint color to be used for the banner's current page indicator.
 *
 *  @since version number 1.0
 */
@property(nonatomic,strong) UIColor *bannerCurrentPageIndicatorTintColor;
@end
