//
//  KTVPitchReverbSelectView.m
//  ktv
//
//  Created by DongYi on 14-6-9.
//
//

#define DEF_DELIVERY    100000

#import "KTVPitchReverbSelectView.h"
#import "Constants.h"
static CGRect __pivotFrame;

@implementation KTVPitchReverbSelectView {
    //选中框
    UIImageView *_ivSelected;
    UIImageView *_ivPivot;
    KTVPitchReverbSelectBlock _blockButtonPressed;
}

#pragma mark - Initialize

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pagingEnabled = YES;
        _nCurrentIndex = 0;
        _nSectionNum = 0;
        UIImage *image = [UIImage imageNamed:@"RecordView_ActionSheet_Bg.png"];
        self.layer.contents = (id) image.CGImage;
        [self initSelectImageView];
    }
    return self;
}

//初始化选中框
- (void)initSelectImageView {
    if (!_ivSelected) {
        _ivSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordView_Pitch_Selected.png"]];
        _ivSelected.userInteractionEnabled = YES;
    }
}

//设置按键和对应标题的选中效果
- (void)setSelectedOnButton:(UIButton *)paramButton {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [(UIButton *)v setSelected:NO];
        }
    }
    paramButton.selected = YES;
    [paramButton addSubview:_ivSelected];
    _currentReverbName = paramButton.titleLabel.text;
}

//视频滤镜
+ (id)defaultVideoFilterEffectSelectViewWithFrame:(CGRect)paramFrame
                                     defaultIndex:(NSInteger)defaultIndex
                                      buttonBlock:(KTVPitchReverbSelectBlock)paramBlock {
    CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, 320.0f);
    KTVPitchReverbSelectView *vSelect = [[self alloc] initWithFrame:paramFrame];
    vSelect.layer.contents = [UIColor clearColor];
    CGFloat fGap = 6.0f;
    CGFloat fButtonWidth = (screenWidth - fGap * 8) / 4.0f;
    vSelect.showsVerticalScrollIndicator = NO;
    vSelect.showsHorizontalScrollIndicator = NO;
    vSelect.pagingEnabled = YES;
    UIButton *btnDefaultSelect = nil;
    [vSelect setBlock:paramBlock];
    int totalButtonNum = 0;
    
    btnDefaultSelect = [vSelect addButtonWithFrame:CGRectMake(fGap + (fGap * 2 + fButtonWidth) * vSelect.nCurrentIndex, 22.0f, fButtonWidth, fButtonWidth)
                                             image:@"RecordView_Video_Render0.png"
                                             title:@"清凉"
                                               vip:NO];
    totalButtonNum ++;
    if (defaultIndex == 0) {
        [vSelect setSelectedOnButton:btnDefaultSelect];
    }
    btnDefaultSelect = [vSelect addButtonWithFrame:CGRectMake(fGap + (fGap * 2 + fButtonWidth) * vSelect.nCurrentIndex, 22.0f, fButtonWidth, fButtonWidth)
                                             image:@"RecordView_Video_Render3.png"
                                             title:@"瘦脸"
                                               vip:NO];
    
    totalButtonNum ++;
    if (defaultIndex == 1) {
        [vSelect setSelectedOnButton:btnDefaultSelect];
    }
    btnDefaultSelect = [vSelect addButtonWithFrame:CGRectMake(fGap + (fGap * 2 + fButtonWidth) * vSelect.nCurrentIndex, 22.0f, fButtonWidth, fButtonWidth)
                                             image:@"RecordView_Video_Render5.png"
                                             title:@"无"
                                               vip:NO];
    
    totalButtonNum ++;
    if (defaultIndex == 2) {
        [vSelect setSelectedOnButton:btnDefaultSelect];
    }
    btnDefaultSelect = [vSelect addButtonWithFrame:CGRectMake(fGap + (fGap * 2 + fButtonWidth) * vSelect.nCurrentIndex, 22.0f, fButtonWidth, fButtonWidth)
                                             image:@"RecordView_Video_Render4.png"
                                             title:@"自然"
                                               vip:NO];
    totalButtonNum ++;
    if (defaultIndex == 3) {
        [vSelect setSelectedOnButton:btnDefaultSelect];
    }
    btnDefaultSelect = [vSelect addButtonWithFrame:CGRectMake(fGap + (fGap * 2 + fButtonWidth) * vSelect.nCurrentIndex, 22.0f, fButtonWidth, fButtonWidth)
                                             image:@"RecordView_Video_Render2.png"
                                             title:@"美颜"
                                               vip:NO];
    totalButtonNum ++;
    
    vSelect.contentSize = CGSizeMake((fGap * 2 + fButtonWidth) * totalButtonNum, paramFrame.size.height);
    return vSelect;
}

#pragma mark - Scroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[KTVPitchReverbSelectView class]]) {
        KTVPitchReverbSelectView *selectView = (KTVPitchReverbSelectView *)scrollView;
        CGFloat fGap = 3.5f;
        CGFloat fButtonWidth = ([UIScreen mainScreen].bounds.size.width - fGap * 5) / 5.5f;
        if (!selectView->_ivPivot) {
            return;
        } else {
            CGPoint offset = selectView.contentOffset;
            CGRect rect = [selectView convertRect:selectView->_ivPivot.frame toView:[[UIApplication sharedApplication].delegate window]];
            if (offset.x >= [UIScreen mainScreen].bounds.size.width + 16.0f) {
                rect = CGRectMake(-(fButtonWidth / 2.0f), rect.origin.y, rect.size.width, rect.size.height);
                selectView->_ivPivot.frame = [selectView convertRect:rect fromView:[[UIApplication sharedApplication].delegate window]];
            } else if (offset.x <= 18.0f) {
                rect = CGRectMake([UIScreen mainScreen].bounds.size.width - fButtonWidth / 2.0f, rect.origin.y, rect.size.width, rect.size.height);
                selectView->_ivPivot.frame = [selectView convertRect:rect fromView:[[UIApplication sharedApplication].delegate window]];
            } else {
                selectView->_ivPivot.frame = __pivotFrame;
            }
        }
    }
}

#pragma mark - Setter

- (void)setBlock:(KTVPitchReverbSelectBlock)paramBlock {
    _blockButtonPressed = paramBlock;
}

#pragma mark - UI Config

//增加新button
- (UIButton *)addButtonWithFrame:(CGRect)paramFrame
                           image:(NSString *)paramStrImage
                           title:(NSString *)paramTitle
                             vip:(BOOL)paramBVIP {
    _nCurrentIndex ++;
    
    //button的配置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = paramFrame;
    [btn setBackgroundImage:[UIImage imageNamed:paramStrImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:paramStrImage] forState:UIControlStateSelected];
    [btn setTitle:paramTitle forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(CGRectGetHeight(paramFrame) + 35.0f, 0.0f, 0.0f, 0.0f)];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [btn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xff7652) forState:UIControlStateSelected];
    if (paramBVIP) {
        //VIP的效果要加蒙层
        UIImageView *vipMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordView_Pitch_VIP.png"]];
        vipMask.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(paramFrame), CGRectGetHeight(paramFrame));
        [btn addSubview:vipMask];
        
        //[btn setImage:[UIImage imageNamed:@"RecordView_Pitch_VIP.png"] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(onButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = [self tagWithSection:_nSectionNum index:_nCurrentIndex];
    [self addSubview:btn];
    
    _ivSelected.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(paramFrame), CGRectGetHeight(paramFrame));
    return btn;
}

//增加分隔
- (void)addPivotWithFrame:(CGRect)paramFrame
                imageName:(NSString *)strImgName {
    _nSectionNum ++;
    _nCurrentIndex = 0;
    _ivPivot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strImgName]];
    _ivPivot.frame = paramFrame;
    __pivotFrame = paramFrame;
    [self addSubview:_ivPivot];
}

- (void)scrollToLeft {
    [self setContentOffset:CGPointZero animated:NO];
}

- (void)scrollToMiddle {
    [self setContentOffset:CGPointMake(150.0f, 0.0f) animated:NO];
}

- (void)scrollToRight {
    CGPoint bottomOffset = CGPointMake(self.contentSize.width - self.bounds.size.width, 0.0f);
    [self setContentOffset:bottomOffset animated:NO];
}

#pragma mark - Button Action

- (void)onButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        //调用界面callback
        NSInteger row, section;
        //获取该button的行列
        [self getSection:&section
                     row:&row
                 withTag:((UIButton *)sender).tag];
        //外部callback
        if (_blockButtonPressed) {
            _blockButtonPressed(section, row);
        }
        
        //更新自身视图
        [self setSelectedOnButton:(UIButton *)sender];
    }
}

#pragma mark - Tag Calculate

- (NSInteger)tagWithSection:(NSInteger)paramSection
                      index:(NSInteger)paramIndex {
    return paramSection * DEF_DELIVERY + paramIndex;
}

- (void)getSection:(NSInteger *)paramSection
               row:(NSInteger *)paramRow
           withTag:(NSInteger)paramTag {
    *paramSection = paramTag / DEF_DELIVERY;
    *paramRow = paramTag % DEF_DELIVERY;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
