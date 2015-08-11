//
//  RHCTBanner.m
//  WliuBanner
//
//  Created by 66 on 15/7/6.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import "WliuBanner.h"

@implementation WliuBanner
- (instancetype)initWithBannerDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic) {
            self.bannerID = [dic objectForKey:@"id"];
            self.bannerImageURLString = [dic objectForKey:@"image"];
            self.bannerLink = [dic objectForKey:@"link"];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"banner:{\n      bannerID:%@\n      bannerImageURL:%@\n      bannerLink:%@\n}", self.bannerID, self.bannerImageURLString, self.bannerLink];
}
@end
