//
//  KTVPitchReverbSelectView
//  ktv
//
//  Created by DongYi on 14-6-9.
//
//

#import <UIKit/UIKit.h>

// 滤镜类型
typedef enum {
    CC_NORMAL_FILTER             = 0,  // 原图
    CC_ANTICOLOR_FILTER          = 1,  // 反色
    CC_EARLYBIRD_FILTER          = 2,  // 马赛克
    CC_EDGE_FILTER               = 3,  // 霓虹灯
    CC_GRAYSCALECONTRAST_FILTER  = 4,  // 黑白
    CC_LOMO_FILTER               = 5,  // 怀旧
    CC_OLDFILM_FILTER            = 6,  // 老照片
    CC_PRO_FILTER                = 7,  // 锐化
    CC_RADIAL_FILTER             = 8,  // 穿越
    CC_BLUECRYSTAL_FILTER        = 9,  // 冷蓝
    CC_JAPANESE_FILTER           = 10, // 日系
    CC_MAPLELEAF_FILTER          = 11, // 枫叶
    CC_SUBDUEDLIGHT_FILTER       = 12, // 柔光
    CC_LAKEWATER_FILTER          = 13, // 湖水
    CC_BULGEDISTORTION_FILTER    = 14, // 凸透镜
    CC_EMBOSS_FILTER             = 15, // 浮雕
    CC_SKETCH_FILTER             = 16, // 素描
    CC_CONTRAST_FILTER           = 17, // 对比
    KTV_YOUYA_FILTER             = 18, // KTV优雅
    KTV_RIXI_FILTER              = 19, // KTV日系
    KTV_QINGLIANG_FILTER         = 20, // KTV清凉
    KTV_FENGJING_FILTER          = 21, // KTV风景画
    KTV_HEIBAI_FILTER            = 22  // KTV黑白
    
} CCFiltersType;

@class KTVPitchReverbSelectView;

typedef void (^KTVPitchReverbSelectBlock)(NSInteger paramSection, NSInteger paramIndex);

@interface KTVPitchReverbSelectView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, readonly) NSInteger nCurrentIndex;
@property (nonatomic, readonly) NSInteger nSectionNum;
@property (nonatomic, strong, readonly) NSString *currentReverbName;

+ (id)defaultVideoFilterEffectSelectViewWithFrame:(CGRect)paramFrame
                                     defaultIndex:(NSInteger)defaultIndex
                                      buttonBlock:(KTVPitchReverbSelectBlock)paramBlock;

//完成页面，用于用户引导
- (void)scrollToMiddle;
- (void)scrollToRight;

@end
