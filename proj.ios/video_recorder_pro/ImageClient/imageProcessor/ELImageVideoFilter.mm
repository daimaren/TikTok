//
//  ELImageVideoFilter.m
//  liveDemo
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 changba. All rights reserved.
//

#import "ELImageVideoFilter.h"

@interface ELImageVideoFilter()  {
    ELImageTextureFrame*                    _inputFrameTexture;
    ELImageVideoProcessor*                  _videoProcessor;
    ELImageTextureFrame*                    _processedFrameTexture;
    unsigned char*                                   _mACVBuffer;
    bool                                    isVideoFilterChanged;
    ELVideoFiltersType                      curELVideoFiltersType;
}

@end

@implementation ELImageVideoFilter

- (id)init
{
    self = [super init];
    if (self) {
        curELVideoFiltersType = PREVIEW_ORIGIN;
    }
    return self;
}

- (ELImageVideoProcessor*) videoProcessor;
{
    if(!_videoProcessor){
        _videoProcessor = [[ELImageVideoProcessor alloc] initWithWidth:[_inputFrameTexture width] height:[_inputFrameTexture height]];
        [_videoProcessor setFilter:PREVIEW_ORIGIN buffer:NULL bufferSize:0];
    }
    return _videoProcessor;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime timimgInfo:(CMSampleTimingInfo)timimgInfo;
{
    if(isVideoFilterChanged){
        //set Filter type mapping
        static NSDictionary* acvDictionary = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            acvDictionary =  @{
                               @(PREVIEW_COOL): @"cool_1"
                               };
        });
        
        //需要acv的filter
        if ([acvDictionary objectForKey:@(curELVideoFiltersType)]) {
            //NSLog(@"acv Filter type.........");
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[acvDictionary objectForKey:@(curELVideoFiltersType)] ofType:@"acv"];
            NSData *myData = [NSData dataWithContentsOfFile:filePath];
            if (myData) {
                //NSLog(@"myData is Valid.........");
                _mACVBuffer = new unsigned char[myData.length];
                memcpy(_mACVBuffer, (unsigned char*)[myData bytes], myData.length);
                [[self videoProcessor] setFilter:curELVideoFiltersType buffer:_mACVBuffer bufferSize:int(myData.length)];
                //NSLog(@"after videoProcessor set filter.........");
            }
        }
        else
        {
            [[self videoProcessor] setFilter:curELVideoFiltersType buffer:NULL bufferSize:0];
        }
        isVideoFilterChanged = false;
        //NSLog(@"setting isVideoFilterChanged false.........");
    }
    float position = 0.5f;
    [[self cameraFrameTexture] activateFramebuffer];
    int width = [_inputFrameTexture width];
    int height = [_inputFrameTexture height];
    [[self videoProcessor] processWithInputTexture:[_inputFrameTexture texture] outputTexture:[_processedFrameTexture texture] width:width height:height position:position];
    for (id<ELImageInput> currentTarget in targets){
        [currentTarget setInputTexture:_processedFrameTexture];
        [currentTarget newFrameReadyAtTime:frameTime timimgInfo:timimgInfo];
    }
}

- (void)setInputTexture:(ELImageTextureFrame *)textureFrame;
{
    _inputFrameTexture = textureFrame;
}


- (ELImageTextureFrame*) cameraFrameTexture;
{
    if(!_processedFrameTexture){
        _processedFrameTexture = [[ELImageTextureFrame alloc] initWithSize:CGSizeMake([_inputFrameTexture width], [_inputFrameTexture height])];
    }
    return _processedFrameTexture;
}


-(void)switchFilter:(ELVideoFiltersType)filterType
{
    if(filterType != curELVideoFiltersType){
        //NSLog(@"switch filter .........");
        curELVideoFiltersType = filterType;
        isVideoFilterChanged = true;
    }
}


@end
