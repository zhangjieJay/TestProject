//
//  sslmCustomSegementView.h
//  ComeHelpMe
//
//  Created by pigbear on 16/8/31.
//  Copyright © 2016年 zxkj. All rights reserved.
//

///******************************************************************************
///* 文档名称： 文件名称
///* 版    本： 1.0
///* 版    权：Copyright (c) 年限 公司名称
///* 创建时间：2016年09月13日10时18分23秒
///* 文档说明：红包中心首页的选项按钮视图
///******************************************************************************



#import "YJBaseView.h"

typedef void(^SelectedIndexBlock)(NSInteger index);

@interface YJCustomSegementView :YJBaseView

/**
 *  数据
 */


@property(nonatomic,strong)NSArray * arrayTitle;
//@property(nonatomic,retain)NSDictionary * titlesDic;//标题的的字典
@property(nonatomic,retain)UIColor * slidingBarColor;//滚动条的颜色,默认为红色



//@property(nonatomic,assign)HDScrollContentType * contentType;//内容样式,是水平放置还是竖向放置,默认为水平放置

@property(nonatomic,strong)UIFont *titleFont;//标题字体
@property(nonatomic,assign)CGFloat slidingBarHeight;//滚动条的高度,默认为2.0
@property(nonatomic,assign)CGFloat nSplitWidth;//按钮间距,
@property(nonatomic,assign)CGFloat nTopSplit;//按钮上下空隙
@property(nonatomic,assign)CGFloat slidingBarLength;//滚动条长度

@property(nonatomic,assign)NSInteger visibleNum;//当前界面显示的最大标题数目
@property(nonatomic,assign)NSInteger nSelecetedIndex;//初始化选中的序号,默认为第一个


@property(nonatomic,assign)BOOL isShowSlidingBar;//是否需要滚动条
@property(nonatomic,assign)BOOL isSameWidthButton;//是否需要等宽的按钮,默认为NO





@end

