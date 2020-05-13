//
//  VideoFilter.m
//  liveDemo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 changba. All rights reserved.
//

#import "ELImageVideoProcessor.h"
#import "video_effect_processor.h"
#import "video_effect_params.h"
#import "video_effect_def.h"

#define PREVIEW_FILTER_SEQUENCE_IN									0
#define PREVIEW_FILTER_SEQUENCE_OUT									10 * 60 * 60 * 1000000

@interface ELImageVideoProcessor ()
{
    int _width;
    int _height;
}

@property (nonatomic) VideoEffectProcessor *processor;
@property (nonatomic) OpenglVideoFrame *inputVideoFrame;
@property (nonatomic) OpenglVideoFrame *outputVideoFrame;
@end

@implementation ELImageVideoProcessor
- (id)initWithWidth:(int) width height:(int)height;
{
    self = [super init];
    if (self) {
        _processor = new VideoEffectProcessor();
        _processor->init();
        _width = width;
        _height = height;
    }
    return self;
}

- (void)dealloc {
    _processor->dealloc();
    delete _processor;
    _processor = NULL;
    
    delete _inputVideoFrame;
    _inputVideoFrame = NULL;
    
    delete _outputVideoFrame;
    _outputVideoFrame = NULL;
}

-(bool)setFilter:(ELVideoFiltersType)filterType buffer:(unsigned char*)mACVBuffer bufferSize:(int)mACVBufferSize
{
    bool ret = true;
    self.processor->removeAllFilters();
    int filterId = [self addFilter:filterType buffer:mACVBuffer bufferSize:mACVBufferSize];
    if(filterId >= 0){
        ret = self.processor->invokeFilterOnReady(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId);
    }
    return ret;
}

-(int)addFilter:(ELVideoFiltersType)filterType
         buffer:(byte*)mACVBuffer
     bufferSize:(int)mACVBufferSize
{
    int filterId = -1;
    switch (filterType) {
        case PREVIEW_COOL:
            filterId = self.processor->addFilter(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, PREVIEW_FILTER_SEQUENCE_IN, PREVIEW_FILTER_SEQUENCE_OUT, BEAUTIFY_FACE_COOL_FILTER_NAME);
            [self setBeautifyFaceFilterValue:filterId maskCurveProgress:0.8 softLightProgress:0.25 hueAngle:0.6 sharpness:0.5 satuRatio:0.25f];
            [self setToneCurveFilterValue:filterId buffer:mACVBuffer bufferSize:mACVBufferSize];
            [self setFilterZoomRatioValue:filterId];
            break;
        case PREVIEW_THIN_FACE:
            filterId = self.processor->addFilter(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, PREVIEW_FILTER_SEQUENCE_IN, PREVIEW_FILTER_SEQUENCE_OUT, THIN_BEAUTIFY_FACE_FILTER_NAME);
            [self setBeautifyFaceFilterValue:filterId maskCurveProgress:0.8 softLightProgress:0.25 hueAngle:0.6 sharpness:0.5 satuRatio:0.25f];
            [self setFilterZoomRatioValue:filterId];
            break;
        case PREVIEW_ORIGIN:
            filterId = self.processor->addFilter(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, PREVIEW_FILTER_SEQUENCE_IN, PREVIEW_FILTER_SEQUENCE_OUT, BEAUTIFY_FACE_FILTER_NAME);
            [self setBeautifyFaceFilterValue:filterId maskCurveProgress:0.8 softLightProgress:0.25 hueAngle:0.6 sharpness:0.5 satuRatio:0.25f];
            [self setFilterZoomRatioValue:filterId];
            break;
        case PREVIEW_WHITENING:
            filterId = self.processor->addFilter(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, PREVIEW_FILTER_SEQUENCE_IN, PREVIEW_FILTER_SEQUENCE_OUT, BEAUTIFY_FACE_FILTER_NAME);
            [self setBeautifyFaceFilterValue:filterId maskCurveProgress:0.4 softLightProgress:0.38 hueAngle:0.4 sharpness:0.5 satuRatio:0.3f];
            [self setFilterZoomRatioValue:filterId];
            break;
        case PREVIEW_NONE:
            filterId = self.processor->addFilter(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, PREVIEW_FILTER_SEQUENCE_IN, PREVIEW_FILTER_SEQUENCE_OUT, BEAUTIFY_FACE_FILTER_NAME);
            [self setBeautifyFaceFilterValue:filterId maskCurveProgress:1.0 softLightProgress:0.15 hueAngle:1.0 sharpness:0.5 satuRatio:0.15f];
            [self setFilterZoomRatioValue:filterId];
            break;
    }
    return filterId;
}

- (void) setBeautifyFaceFilterValue:(int)filterId maskCurveProgress:(float)maskCurveProgress
                  softLightProgress:(float)softLightProgress hueAngle:(float) hueAngle sharpness:(float) sharpness satuRatio:(float)satuRatio;
{
    ParamVal textureWidthValue;
    textureWidthValue.u.intVal = _width;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, WHITENING_FILTER_TEXTURE_WIDTH, textureWidthValue);
    ParamVal textureHeightValue;
    textureHeightValue.u.intVal = _height;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, WHITENING_FILTER_TEXTURE_HEIGHT, textureHeightValue);
    ParamVal smoothSkinEffectParamChangedValue;
    smoothSkinEffectParamChangedValue.u.boolVal = true;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, SMOOTH_SKIN_EFFECT_PARAM_CHANGED, smoothSkinEffectParamChangedValue);
    ParamVal maskCurveProgressValue;
    maskCurveProgressValue.u.fltVal = maskCurveProgress;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, MASK_CURVE_PROGRESS, maskCurveProgressValue);
    ParamVal softLightProgressValue;
    softLightProgressValue.u.fltVal = softLightProgress;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, SOFT_LIGHT_PROGRESS, softLightProgressValue);
    ParamVal satuRatioValue;
    satuRatioValue.u.fltVal = satuRatio;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, SATU_RATIO, satuRatioValue);
    ParamVal hueAngleChangedValue;
    hueAngleChangedValue.u.boolVal = true;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, HUE_EFFECT_HUE_ANGLE_CHANGED, hueAngleChangedValue);
    ParamVal hueAngleValue;
    hueAngleValue.u.fltVal = hueAngle;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, HUE_EFFECT_HUE_ANGLE, hueAngleValue);
    ParamVal sharpnessValue;
    sharpnessValue.u.fltVal = sharpness;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, SHARPEN_EFFECT_SHARPNESS, sharpnessValue);
    ParamVal groupEffectWidthValue;
    groupEffectWidthValue.u.intVal = _width;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, IMAGE_EFFECT_GROUP_TEXTURE_WIDTH, groupEffectWidthValue);
    ParamVal groupEffectHeightValue;
    groupEffectHeightValue.u.intVal = _height;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, IMAGE_EFFECT_GROUP_TEXTURE_HEIGHT, groupEffectHeightValue);
}

-(void)setToneCurveFilterValue:(int)filterId buffer:(byte*)mACVBuffer bufferSize:(int)mACVBufferSize
{
    ParamVal changeFlagValue;
    changeFlagValue.u.boolVal = true;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, TONE_CURVE_FILTER_ACV_BUFFER_CHANGED, changeFlagValue);
    ParamVal acvBufferValue;
    acvBufferValue.u.arbData = mACVBuffer;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, TONE_CURVE_FILTER_ACV_BUFFER, acvBufferValue);
    ParamVal acvBufferSizeValue;
    acvBufferSizeValue.u.intVal = mACVBufferSize;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, TONE_CURVE_FILTER_ACV_BUFFER_SIZE, acvBufferSizeValue);
}

-(void)setFilterZoomRatioValue:(int)filterId
{
    ParamVal zoomRatioValue;
    zoomRatioValue.u.fltVal = 0.95;
    self.processor->setFilterParamValue(EFFECT_PROCESSOR_VIDEO_TRACK_INDEX, filterId, IMAGE_EFFECT_ZOOM_VIEW_RATIO, zoomRatioValue);
}

- (void)processWithInputTexture:(int)inputTexId outputTexture:(int)outputTexId width:(int)width height:(int)height position:(float)position; {
    GL_CHECK_ERROR("KTVMVFilter at the beginning of renderToTexture");
    ImagePosition imagePosition;
    imagePosition.x = 0;
    imagePosition.y = 0;
    imagePosition.width = width;
    imagePosition.height = height;
    
    if (!self.inputVideoFrame) {
        self.inputVideoFrame = new OpenglVideoFrame(inputTexId, imagePosition);
    } else {
        self.inputVideoFrame->init(inputTexId, imagePosition);
    }
    
    if (!self.outputVideoFrame) {
        self.outputVideoFrame = new OpenglVideoFrame(outputTexId, imagePosition);
    } else {
        self.outputVideoFrame->init(outputTexId, imagePosition);
    }
    
    GL_CHECK_ERROR("KTVMVFilter before process");
    self.processor->process(self.inputVideoFrame, position, self.outputVideoFrame);
    GL_CHECK_ERROR("KTVMVFilter after process");
}

#pragma mark - Utility
+ (void)checkGLError {
    GLenum glError = glGetError();
    if (glError != GL_NO_ERROR) {
        NSLog(@"GL error: 0x%x", glError);
    }
}
@end
