//
//  sslmCustomSegementView.m
//  ComeHelpMe
//
//  Created by pigbear on 16/8/31.
//  Copyright © 2016年 zxkj. All rights reserved.
//

#import "YJCustomSegementView.h"
#import "YJSegementButton.h"

@interface YJCustomSegementView()

@property(nonatomic,copy)SelectedIndexBlock block;
@property(nonatomic,retain)NSMutableArray * muWidthArray;//按钮的宽度
@property(nonatomic,retain)NSMutableArray * btnArray;//存放button的数组


/**
 *  视图
 */

@property(nonatomic,retain)UIScrollView * backScrollView;//滚动视图
@property(nonatomic,retain)UIView * slidingBarView;//滚动条

@end

@implementation YJCustomSegementView{
    
    NSInteger totalNum;//总标题数
    CGRect ViewFrame;//当前视图的Frame
    NSInteger pnFlag;//该窗体的flag值
    CGFloat btnWidth;//按钮宽度
    CGFloat btnHeight;//按钮高度
    YJSegementButton * btnCurrent;//当前选中的按钮
    UIView * viewTopSeperator;//顶部分割线
    NSInteger nTag;//
    
    BOOL isOutOfBound;//是否超出边界
    
    
    
}


- (instancetype)init
{
    return  [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ViewFrame = frame;
        [self initDeadultParams];
        [self initBaseControl];
        
    }
    return self;
}

//初始化参数,
-(void)initDeadultParams
{
    _isSameWidthButton = YES;//默认按钮等宽
    _isShowSlidingBar = YES;//显示滚动条
    
    _slidingBarLength = 80.f;
    _slidingBarHeight = 2.f;//滚动条高度为2
    _titleFont = [UIFont systemFontOfSize:12.f];//标题字体为15
    _nSplitWidth = 0.f;//左右边距
    _nTopSplit  = 3;
    btnWidth = 60;
    _visibleNum = 4;//单个屏幕显示的个数
    
    nTag = 50;
    
    _slidingBarColor = [UIColor redColor];
    _btnArray = [NSMutableArray array];
    _muWidthArray = [NSMutableArray array];
    
}

-(void)initBaseControl
{
    //*******页面滚动视图**********
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ViewFrame.size.width, ViewFrame.size.height)];
    _backScrollView.backgroundColor = [UIColor whiteColor];
    _backScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_backScrollView];
    
    //*******初始化顶部分割线**********
    viewTopSeperator = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ViewFrame.size.width, 0.5)];
    viewTopSeperator.backgroundColor = [UIColor grayColor];
    [_backScrollView addSubview:viewTopSeperator];
    
    
    //*******初始化滚动条**********
    CGRect rect = CGRectMake(_nSplitWidth, ViewFrame.size.height - _slidingBarHeight, btnWidth , _slidingBarHeight);
    _slidingBarView = [[UIView alloc]initWithFrame:rect];
    [self.backScrollView addSubview:_slidingBarView];
    _slidingBarView.backgroundColor = _slidingBarColor;
    _slidingBarView.frame = CGRectMake(_slidingBarView.frame.origin.x,self.frame.size.height - _slidingBarHeight, btnWidth, _slidingBarHeight);
    
    
}



-(void)setArrayTitle:(NSArray *)arrayTitle{
    _arrayTitle = arrayTitle;
    totalNum = _arrayTitle.count;
    [self getWidthArray];//给宽度数组赋值
    [self initUserInterface];//初始化视图
}


-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    [self getWidthArray];//给宽度数组赋值
}

-(void)setVisibleNum:(NSInteger)visibleNum{
    _visibleNum = visibleNum;
    [self initUserInterface];//初始化视图
}




-(void)setNSelecetedIndex:(NSInteger)nSelecetedIndex
{
    if(nSelecetedIndex>totalNum-1 || nSelecetedIndex<0)
    {
        return;
    }
    
    UIView *view =[self.backScrollView viewWithTag:nSelecetedIndex+nTag];
    if(view ==nil)
    {
        return;
    }
    
    YJSegementButton * targetBtn = (YJSegementButton *)view;
    
    if (btnCurrent == targetBtn) {
        [self runSlidingBarAnimationWithSender:targetBtn];
        return;
    }
    
    btnCurrent.enabled = YES;
    btnCurrent =targetBtn;
    btnCurrent.enabled = NO;
    [self runSlidingBarAnimationWithSender:(YJSegementButton *)view];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

/**
 *  懒加载创建对象
 */

-(UIView *)slidingBarView{
    
    if (!_slidingBarView) {
        
        CGRect rect = CGRectMake(_nSplitWidth, self.frame.size.height - _slidingBarHeight, btnWidth , _slidingBarHeight);
        
        _slidingBarView = [[UIView alloc]initWithFrame:rect];
        
        [self.backScrollView addSubview:_slidingBarView];
    }
    _slidingBarView.backgroundColor = _slidingBarColor;
    _slidingBarView.frame = CGRectMake(_slidingBarView.frame.origin.x,self.frame.size.height - _slidingBarHeight, btnWidth, _slidingBarHeight);
    return _slidingBarView;
    
}


/**
 *  根据字数获取按钮的宽度存入数组
 */
-(void)getWidthArray
{
    
    NSString * sTemp;
    int nWidth =0;
    [_muWidthArray removeAllObjects];
    
    for (NSInteger i = 0; i < totalNum; i++) {
        if (!_arrayTitle[i]) {
            nWidth = [CUTool autoSizeWithString:@"" font:_titleFont width:MAXFLOAT].width;
            [_muWidthArray addObject:[NSString stringWithFormat:@"%d",nWidth]];
            continue;
        }
        sTemp = _arrayTitle[i];
        //获取字体根据字号的长度
        nWidth = [CUTool autoSizeWithString:sTemp font:_titleFont width:MAXFLOAT].width + _titleFont.pointSize * 0.2;
        [_muWidthArray addObject:[NSString stringWithFormat:@"%d",nWidth]];
        
    }
}


//初始化界面
-(void)initUserInterface{
    if (totalNum < 1) {
        return;//未设置标题，直接返回
    }
    if (totalNum >=4) {//总标题数大于4
        if (_visibleNum != 4) {//用户是否设置了最大显示上限
            if (_visibleNum > 6) {
                _visibleNum = 6;//用户设置了6个以上则按照6各处理
            }
        }
    }else{
        
        _visibleNum = _arrayTitle.count;//小于4
    }
    
    CGFloat nbtnWidth=0;
    
    btnHeight = self.frame.size.height - 2 * _nTopSplit;
    
    int nX=0;
    
    for (NSInteger i = 0; i < totalNum; i++) {
        YJSegementButton * tempButton = [self.backScrollView viewWithTag:i+nTag];
        if (!tempButton) {
            tempButton=[YJSegementButton buttonWithType:UIButtonTypeCustom];
            [tempButton setTitle:_arrayTitle[i] forState:UIControlStateNormal] ;
            [tempButton setTitle:_arrayTitle[i] forState:UIControlStateDisabled] ;
            [tempButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            [tempButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            tempButton.tag = i + nTag;
            //一个赋值为当前button
            if (i == 0) {
                tempButton.enabled = NO;
                btnCurrent = tempButton;
            }
            
            [_btnArray addObject:tempButton];
            [tempButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.backScrollView addSubview:tempButton];
            
        }
        
        
        
        nbtnWidth=[[_muWidthArray objectAtIndex:i] floatValue];
        nX+=_nSplitWidth;
        if (_isSameWidthButton) {
            
            nbtnWidth = (self.frame.size.width - ((_visibleNum -1) * 2 + 2) * _nSplitWidth)/(_visibleNum * 1.0);
        }
        
        btnWidth = nbtnWidth;
        tempButton.frame = CGRectMake(nX, _nTopSplit, nbtnWidth, btnHeight);
        
        if (!tempButton.enabled) {
            if(self.isShowSlidingBar){
                [self runSlidingBarAnimationWithSender:tempButton];
            }
        }
        
        tempButton.titleLabel.font = _titleFont;
        nX+=btnWidth+_nSplitWidth;
        
    }
    
    //当界面不能显示全部的标题,则调整滚动视图的contentsize
    if (_visibleNum<totalNum) {
        
        int nTmp =0;
        
        if (_isSameWidthButton) {
            
            for(NSInteger i =0;i<totalNum;i++){
                
                nTmp += btnWidth +_nSplitWidth * 2;
            }
            
        }else{
            
            for(NSInteger i =0;i<totalNum;i++)
            {
                nTmp+=[[_muWidthArray objectAtIndex:i] intValue]+_nSplitWidth * 2;
                
            }
        }
        if (nTmp > ViewFrame.size.width) {
            isOutOfBound = YES;
            
        }else{
        
            isOutOfBound = NO;
            self.frame = CGRectMake(ViewFrame.origin.x, ViewFrame.origin.y, nTmp, ViewFrame.size.height);
            self.backScrollView.frame = CGRectMake(0, 0, nTmp, ViewFrame.size.height);
            ViewFrame=self.frame;
        }
        
        self.backScrollView.contentSize = CGSizeMake(nTmp, ViewFrame.size.height);
        CGRect sepFrame = viewTopSeperator.frame;
        sepFrame.size.width = nTmp;
        viewTopSeperator.frame = sepFrame;
    }
    
    [_backScrollView bringSubviewToFront:viewTopSeperator];
    
}

//按钮点击事件
-(void)titleButtonClicked:(YJSegementButton *)sender{
    
    if([sender isKindOfClass:[YJSegementButton class]])
    {
        
        btnCurrent.enabled = YES;//前一个按钮可用
        btnCurrent = sender;//当前点击按钮设置为当前按钮
        btnCurrent.enabled = NO;//当前点击按钮禁用
        
        //调用滚动条的函数>>>>>
        if(self.isShowSlidingBar){
            [self runSlidingBarAnimationWithSender:sender];
        }
        
        if (self.block) {
            self.block(sender.tag);
            
            
        }else{
            
            NSLog(@"点击事件block未实现,如果需要请实现方法:didClickedButtonAtIndex:");
        }
    }
}





//滚动条动画
-(void)runSlidingBarAnimationWithSender:(YJSegementButton *)sender{
    
    if([sender isKindOfClass:[YJSegementButton class]])
    {
        CGRect nextRect;
        if (_isSameWidthButton) {
            nextRect =CGRectMake(sender.frame.origin.x + btnWidth/2.0 - _slidingBarLength /2.0, self.frame.size.height - _slidingBarHeight, _slidingBarLength, _slidingBarHeight);
        }else{
            nextRect =CGRectMake(sender.frame.origin.x, self.frame.size.height - _slidingBarHeight, sender.frame.size.width, _slidingBarHeight);
        }
        
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.slidingBarView.frame = nextRect;
            
            if (_visibleNum < totalNum) {
                
                CGFloat originX = (sender.frame.origin.x + sender.frame.size.width/2.0);
                
                if (originX < (self.frame.size.width/2.0)) {
                    
                    originX = 0;
                }
                else if ((originX + (self.frame.size.width/2.0)) > self.backScrollView.contentSize.width){
                    
                    originX =self.backScrollView.contentSize.width - self.frame.size.width;
                }
                else{
                    originX = originX - self.frame.size.width/2.0;
                    
                }
                if (isOutOfBound) {
                    self.backScrollView.contentOffset =CGPointMake(originX, 0);

                }
                
            }
            
        } completion:^(BOOL finished) {
            
            NSLog(@"滚动条滚动完毕");
            
        }];
        
    }
    
}


@end

