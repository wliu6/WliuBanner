//
//  WliuImageCache.h
//  WliuBanner
//
//  Created by 66 on 15/7/6.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^WliuImageCacheNoParamsBlock)();

@interface WliuBannerImageCache : NSObject

/*!
 *  @author 66, 15-07-14
 *
 *  @brief  Instance of ' WliuBannerImageCache '
 *
 *  @return WliuBannerImageCache obj
 *
 *  @since version number 1.0
 */
+ (WliuBannerImageCache *)sharedImageCache;

/*!
 *  @author 66, 15-07-07
 *
 *  @brief  remove useless images form disk
 *
 *  @param array The array is that banner appeared image keys' collection.The key's content image's url or image's name
 *
 *  @since version number 1.0
 */
- (void)removeUselessImagesWithUsedImagesKeysArray:(NSArray *)array;


/*!
 *  @author 66, 15-07-07
 *
 *  @brief  save image to memory with key
 *
 *  @param image the target image,that store to memory
 *  @param key   key image's url or image's name
 *
 *  @since version number 1.0
 */
- (void)storeToMemoryImage:(UIImage *)image ForKey:(NSString *)key;

/*!
 *  @author 66, 15-07-07
 *
 *  @brief  save image to disk with key
 *
 *  @param imageData the target image's data,that store to disk
 *  @param key       key image's url or image's name
 *
 *  @since version number 1.0
 */
- (void)storeToDiskImageWithImageData:(NSData *)imageData ForKey:(NSString *)key;

/*!
 *  @author 66, 15-07-07
 *
 *  @brief  clear disk
 *
 *  @since version number 1.0
 */
- (void)clearDisk;

/*!
 *  @author 66, 15-07-07
 *
 *  @brief  clear disk and used block to do something when disk had been cleared
 *
 *  @param completion The block is used when disk had been cleared.
 *
 *  @since version number 1.0
 */
- (void)clearDiskOnCompletion:(WliuImageCacheNoParamsBlock)completion;


// memory
- (BOOL)memoryCacheHasImageWithKey:(NSString *)key;

- (UIImage *)imageFromMemoryCacheWithKey:(NSString *)key;

// disk
- (BOOL)diskHasImageWithKey:(NSString *)key;

- (UIImage *)imageFromDiskWithKey:(NSString *)key;
@end
