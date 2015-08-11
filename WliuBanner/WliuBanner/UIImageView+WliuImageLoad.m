//
//  UIImageView+WliuImageLoad.m
//  WliuBanner
//
//  Created by 66 on 15/7/9.
//  Copyright (c) 2015年 w66. All rights reserved.
//
#pragma mark - headers
#import "UIImageView+WliuImageLoad.h"
#import "WliuBannerImageCache.h"
#import "WliuBannerMacroHeader.h"

#pragma mark - Auxiliary Class
//@interface WliuOperationQueue : NSOperationQueue
//
//@end
//@implementation WliuOperationQueue
//
//+ (instancetype)sharedOperationQueue
//{
//    static WliuOperationQueue *opQueue;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        opQueue = [[WliuOperationQueue alloc] init];
//        opQueue.name = @"loadingBannerImage";
//    });
//    return opQueue;
//}
//
//@end
#pragma mark - motheds
@implementation UIImageView (WliuImageLoad)
#pragma mark - private mothed
- (BOOL)checkArrayMemberIsImageObjWith:(id)obj
{
    return [obj isKindOfClass:[UIImage class]];
}

- (void)loadingImageWithURL:(NSURL *)url completion:(WliuImageLoadCompletionBlock)completion
{
    if (!url) return ;
    
    UIImageView *wself = self;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    if (wself) {
        NSString *imageStoreKey = [url absoluteString];
        UIImage *cacheImage = [[WliuBannerImageCache sharedImageCache] imageFromDiskWithKey:imageStoreKey];
        if (cacheImage) {
            if (!wself) return ;
            
            __strong UIImageView *sself = wself;
            if (sself) {
                if (sself.isAnimating) {
                    [sself stopAnimating];
                }
                sself.image = cacheImage;
                if (completion) {
                    completion(YES,cacheImage);
                }
            }
            return ;
        }
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError) {
                [self loadingImageWithURL:url completion:completion];
            }
            if (!wself) return ;
            
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                
                dispatch_main_sync_safe(^{
                    if (!wself) return ;
                    
                    __strong UIImageView *sself = wself;
                    if (sself && image) {
                        if (sself.isAnimating) {
                            [sself stopAnimating];
                        }
                        sself.image = image;
                        
                        // store image
                        [[WliuBannerImageCache sharedImageCache] storeToMemoryImage:image ForKey:imageStoreKey];
                        
                        [[WliuBannerImageCache sharedImageCache] storeToDiskImageWithImageData:data ForKey:imageStoreKey];
                    }
                    
                    if (completion) {
                        completion(YES, image);
                    }
                });
            }else{
                if (completion) {
                    completion(NO, nil);
                }
#warning Perhaps the image file is ' NULL ' or the image file's type isn't ' PNG/JPG '
            }
        }];
    }
}
#pragma mark - static placeholder
- (void)w6_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(WliuImageLoadCompletionBlock)completion
{
    if (!url || !placeholder) {
        return ;
    }
    
    __weak UIImageView *wself = self;
    
    dispatch_main_sync_safe(^{
        if (!wself) return ;
        __strong UIImageView *sself = wself;
        if (sself) {
            sself.image = placeholder;
        }
    });
    
    [self loadingImageWithURL:url completion:completion];
}

- (void)w6_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self w6_setImageWithURL:url placeholderImage:placeholder completion:nil];
}

#pragma mark -  dynamic placeholder
- (void)w6_setImageWithURL:(NSURL *)url placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration completion:(WliuImageLoadCompletionBlock)completion
{
    if (!url || !placeholders) {
        return ;
    }
    
    NSMutableArray *animationImagesArray = [placeholders mutableCopy];
    if (animationImagesArray.count) {
        // delete placeholders' member isn't class of 'UIImage'.
        for (int index = 0; index < animationImagesArray.count; index ++) {
            id tempMember = animationImagesArray[index];
            if (![self checkArrayMemberIsImageObjWith:tempMember]) {
                [animationImagesArray removeObject:tempMember];
            }
        }
    }
    
    if (animationImagesArray.count == 1) {
        [self w6_setImageWithURL:url placeholderImage:[animationImagesArray firstObject] completion:completion];
    }
    
    __weak UIImageView *wself = self;
    dispatch_main_sync_safe(^{
        if (!wself) return ;
        __strong UIImageView *sself = wself;
        if (sself) {
            sself.animationImages = animationImagesArray;
            sself.animationDuration = animationDuration;
            [sself startAnimating];
        }
    });
    
    [self loadingImageWithURL:url completion:completion];
}

- (void)w6_setImageWithURL:(NSURL *)url placeholderImages:(NSArray *)placeholders animationDuration:(double)animationDuration
{
    [self w6_setImageWithURL:url placeholderImages:placeholders animationDuration:animationDuration completion:nil];
}
@end
