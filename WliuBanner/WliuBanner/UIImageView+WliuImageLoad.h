//
//  UIImageView+WliuImageLoad.h
//  WliuBanner
//
//  Created by 66 on 15/7/9.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WliuImageLoadCompletionBlock)(BOOL completion , UIImage *image);

@interface UIImageView (WliuImageLoad)
#pragma mark - static placeholder
/*!
 *  @author 66, 15-07-10
 *
 *  @brief  async loading image
 *
 *  @param url         image's URL
 *  @param placeholder placeholder image
 *  @param completion  A block called when operation has been completed. This block return A 'BOOL' value, that 'BOOL' value
 *
 *  @since version number 1.0
 */
- (void)w6_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(WliuImageLoadCompletionBlock)completion;

/*!
 *  @author 66, 15-07-13
 *
 *  @brief  async loading image
 *
 *  @param url         image's URL
 *  @param placeholder placeholder image
 *
 *  @since version number 1.0
 */
- (void)w6_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

#pragma mark -  dynamic placeholder
/*!
 *  @author 66, 15-07-10
 *
 *  @brief  async loading image
 *
 *  @param url         image's URL
 *  @param placeholders placeholder images array
 *  @param animationDuration placeholder animation duration
 *  @param completion  A block called when operation has been completed. This block return A 'BOOL' value, that 'BOOL' value
 *
 *  @since version number 1.0
 */
- (void)w6_setImageWithURL:(NSURL *)url placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration completion:(WliuImageLoadCompletionBlock)completion;


/*!
 *  @author 66, 15-07-13
 *
 *  @brief  async loading image
 *
 *  @param url         image's URL
 *  @param placeholders placeholder images array
 *  @param animationDuration placeholder animation duration
 *
 *  @since version number 1.0
 */
- (void)w6_setImageWithURL:(NSURL *)url placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration;
@end
