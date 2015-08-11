//
//  WliuBannerMacroHeader.h
//  WliuBanner
//
//  Created by 66 on 15/7/16.
//  Copyright (c) 2015年 w66. All rights reserved.
//

#ifndef WliuBanner_WliuBannerMacroHeader_h
#define WliuBanner_WliuBannerMacroHeader_h

#pragma mark - thread safe
#define dispatch_main_sync_safe(block)\
if([NSThread isMainThread]){\
block();\
}else{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#endif
