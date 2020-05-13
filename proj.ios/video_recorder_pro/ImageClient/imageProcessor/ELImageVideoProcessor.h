//
//  VideoFilter.h
//  liveDemo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 changba. All rights reserved.
//

#import <Foundation/Foundation.h>

// 滤镜类型
typedef enum {
    PREVIEW_COOL                 = 10000,      // 清凉
    PREVIEW_THIN_FACE            = 10001,      // 瘦脸
    PREVIEW_NONE                 = 10002,      // 无
    PREVIEW_ORIGIN               = 10003,      // 自然
    PREVIEW_WHITENING            = 10004,      // 美颜
} ELVideoFiltersType;

@interface ELImageVideoProcessor : NSObject

- (id)initWithWidth:(int) width height:(int)height;

- (void)processWithInputTexture:(int)inputTexId outputTexture:(int)outputTexId width:(int)width height:(int)height position:(float)position;

-(bool)setFilter:(ELVideoFiltersType)filterType buffer:(unsigned char*)mACVBuffer bufferSize:(int)mACVBufferSize;

@end
