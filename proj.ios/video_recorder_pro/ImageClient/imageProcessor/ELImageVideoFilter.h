//
//  ELImageVideoFilter.h
//  liveDemo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 changba. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELImageContext.h"
#import "ELImageOutput.h"
#import "ELImageVideoProcessor.h"

@interface ELImageVideoFilter : ELImageOutput <ELImageInput>

-(void)switchFilter:(ELVideoFiltersType)filterType;

@end
