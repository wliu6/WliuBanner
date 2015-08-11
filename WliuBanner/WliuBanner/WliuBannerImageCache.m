//
//  WliuImageCache.m
//  WliuBanner
//
//  Created by 66 on 15/7/6.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import "WliuBannerImageCache.h"
#import <CommonCrypto/CommonDigest.h>


@interface WliuBannerImageCache ()
@property (strong, nonatomic) NSCache *memoryCache;
@property (strong, nonatomic) NSString *diskRootCachePath;
@property (strong, nonatomic) dispatch_queue_t ioQueue;
@end

@implementation WliuBannerImageCache
{
    NSFileManager *_fileManager;
}

+ (WliuBannerImageCache *)sharedImageCache
{
    static WliuBannerImageCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [WliuBannerImageCache new];
    });
    return imageCache;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *rootBannerImageCachePathName = @"com.Wliu.BannerImageCache.default";
        
        // Init I/O queue
        _ioQueue = dispatch_queue_create("com.Wliu.BannerImageCache", NULL);
        
        // Init the memory cache
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = rootBannerImageCachePathName;
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskRootCachePath = [paths[0] stringByAppendingPathComponent:rootBannerImageCachePathName];
        
        // Init file manager
        dispatch_sync(_ioQueue, ^{
            _fileManager = [[NSFileManager alloc]init];
        });


#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
        
    }
    return self;
}

#pragma mark - 'add / delete / get' image to disk or memory
#pragma mark -- add
// add image to memory
- (void)storeToMemoryImage:(UIImage *)image ForKey:(NSString *)key
{
    if (!image || !key) {
        return ;
    }
    [self.memoryCache setObject:image forKey:key cost:image.size.width * image.size.height * image.scale * image.scale];
}
// add image to disk
- (void)storeToDiskImageWithImageData:(NSData *)imageData ForKey:(NSString *)key;
{
    if (!imageData || !key) {
        return ;
    }
    dispatch_async(self.ioQueue, ^{
        if (![_fileManager fileExistsAtPath:_diskRootCachePath]) {
            [_fileManager createDirectoryAtPath:_diskRootCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        NSString *filePath = [_diskRootCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
        [_fileManager createFileAtPath:filePath contents:imageData attributes:nil];
    });
}
#pragma mark -- delete
- (void)removeUselessImagesWithUsedImagesKeysArray:(NSArray *)array
{
    if (array) {
        NSArray *subPathsArray = [_fileManager subpathsAtPath:_diskRootCachePath];
        if (subPathsArray) {
            dispatch_async(self.ioQueue, ^{
                for (NSString *subPath in subPathsArray) {
                    if (![array containsObject:subPath]) {
                        NSString *removePath = [_diskRootCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:subPath]];
                        [_fileManager removeItemAtPath:removePath error:nil];
                    }
                }
            });
        }
    }
}
#pragma mark -- get
// memory
- (BOOL)memoryCacheHasImageWithKey:(NSString *)key
{
    BOOL result = NO;
    if ([self.memoryCache objectForKey:key]) {
        result = YES;
    }else{
        
    }
    return result;
}

- (UIImage *)imageFromMemoryCacheWithKey:(NSString *)key
{
    UIImage *targetImage ;
    id result = [self.memoryCache objectForKey:key];
    if ([result isKindOfClass:[UIImage class]]) {
        targetImage = result;
    }
    return targetImage;
}

// disk
- (BOOL)diskHasImageWithKey:(NSString *)key
{
    BOOL result = NO;
    result = [[NSFileManager defaultManager] fileExistsAtPath:[self.diskRootCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]]];
    return result;
}

- (UIImage *)imageFromDiskWithKey:(NSString *)key
{
    UIImage *targetImage = [self imageFromMemoryCacheWithKey:key];
    if (targetImage) {
        return targetImage;
    }
    NSString *imagePath = [self.diskRootCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    if (imageData) {
        UIImage *resultImage = [UIImage imageWithData:imageData];
        if (resultImage) {
            [self storeToMemoryImage:resultImage ForKey:key];
            return resultImage;
        }
    }
    return targetImage;
}

#pragma mark - about clear
- (void)clearMemory
{
    [self.memoryCache removeAllObjects];
}
- (void)clearDisk
{
    [self clearDiskOnCompletion:nil];
}
- (void)clearDiskOnCompletion:(WliuImageCacheNoParamsBlock)completion
{
    dispatch_async(_ioQueue, ^{
        [_fileManager removeItemAtPath:self.diskRootCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskRootCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

#pragma mark - filename

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}


@end
