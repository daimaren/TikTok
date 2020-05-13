#define UIColorFromRGB(rgbValue)                    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBCOLOR(r,g,b)                             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#ifndef IOS9
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#endif

#ifndef IOS8
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif

#ifndef IOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif

#define IOS7_OR_LATER                               ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS_OR_LATER(v)                             ([[[UIDevice currentDevice] systemVersion] compare:[NSString stringWithFormat:@"%f",v]] != NSOrderedAscending)

#define BarButtonWithTitle(TITLE,TARGET,SELECTOR)   [UIBarButtonItem barButtonItemWithTitle:TITLE target:TARGET action:SELECTOR]
#define BarButtonWithImage(IMAGE,TARGET,SELECTOR)   [UIBarButtonItem barButtonItemWithImage:IMAGE target:TARGET action:SELECTOR]
#define BackBarButtonItem(TARGET,SELECTOR)          [UIBarButtonItem backButtonItemWithTarget:TARGET action:SELECTOR]

#define DeltaHeight                                 (IOS7_OR_LATER ? 20 : 0)

#define IS_RETINA                                   ([UIScreen instancesRespondToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] > 1.0 : NO)

#define APPSTORE                                    [CHANNEL isEqualToString:@"appstore"]

#define BundleName                                  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]

#define SizePerPage                                 20
#define ThresholdOfLoadMore                         10

#define CELL_SMALL_FONT                             [UIFont systemFontOfSize:14.0]
#define CELL_NORMALL_FONT                           [UIFont systemFontOfSize:16.0]
#define CELL_LARGE_FONT                             [UIFont systemFontOfSize:18.0]
#define CELL_TEXT_BROWN_COLOR                       UIColorFromRGB(0xb57761)
#define CELL_LIANGHAO_RED_COLOR                     UIColorFromRGB(0xe9513d)
#define CELL_LIANGHAO_GRAY_COLOR                     UIColorFromRGB(0xcccccc)

#define ScreenSize                                  [UIScreen mainScreen].bounds.size
#define HeightRatioScreen(defaultH)                 floorf(defaultH * ScreenSize.width / 320.0f)

#define Font_System(fontSize)                       [UIFont systemFontOfSize:fontSize]
#define Font_BoldSystem(fontSize)                   [UIFont boldSystemFontOfSize:fontSize]

#define iOS70TopMargin                              64.0f

#define TABBAR_HEIGHT                               49.0f

#define STATUSBAR_HEIGHT                            20.0f

#define NAV_BAR_HEIGHT                              44.0f

//判断版本宏定义
#define SystemVersionEqualTo(version)   ([[[UIDevice currentDevice] systemVersion] floatValue] == version)

#define SystemVersionEqualTo70          SystemVersionEqualTo(7.0)

#define iOSTopMargin                    (SystemVersionEqualTo70 ? iOS70TopMargin : 0.0f)

#define ContentHeightWithoutTop64       ScreenSize.height - (SystemVersionEqualTo70 ? 0.0 :iOS70TopMargin)

#define ContentHeightWithoutTop64Func(hasTabBar)   (hasTabBar ? (ContentHeightWithoutTop64-TABBAR_HEIGHT):ContentHeightWithoutTop64)

/** Convert from degrees to radians */
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

/** Convert from radians to degrees */
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)


#define weakify(var) __weak typeof(var) KTVWeak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = KTVWeak_##var; \
_Pragma("clang diagnostic pop")
