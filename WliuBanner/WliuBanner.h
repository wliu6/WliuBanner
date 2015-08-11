//
//  RHCTBanner.h
//  WliuBanner
//
//  Created by 66 on 15/7/6.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WliuBanner : NSObject

/*!
 *  @brief  banner_id
 */
@property(nonatomic,copy) NSString *bannerID;

/*!
 *  @brief  banner_image
 */
@property(nonatomic,strong) NSString *bannerImageURLString;

/*!
 *  @brief  banner_link,
 */
@property(nonatomic,copy) NSString *bannerLink;

- (instancetype)initWithBannerDic:(NSDictionary *)dic;
@end
