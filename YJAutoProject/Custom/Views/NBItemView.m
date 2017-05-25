//
//  NBItemView.m
//  YJAutoProject
//
//  Created by 峥刘 on 17/4/21.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "NBItemView.h"


@interface NBItemView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * itemTableView;//表格视图
@property(nonatomic,copy)NSArray * dataArray;//数据源
@property(nonatomic,copy)NSString * title;

@end

@implementation NBItemView{

    NSString * sCellID;//复用ID

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */


- (void)drawRect:(CGRect)rect {
     //Drawing code
    
    
    
}



- (instancetype)initWithTitle:(NSString *)sTitle itemsArray:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, 375, 603);
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.2];
        sCellID = [NSString stringWithFormat:@"NBITEM_CELL_IDENTIFIER"];
        self.dataArray = items;
        self.title = sTitle;
        [self addSubview:self.itemTableView];
    }
    return self;
}


-(UITableView *)itemTableView{

    if (!_itemTableView) {
        _itemTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        [_itemTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCellID];
        _itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _itemTableView.separatorInset = UIEdgeInsetsMake(0, 44, 0, 0);
        _itemTableView.delegate = self;
        _itemTableView.dataSource = self;
    }

    return _itemTableView;
}

#pragma mark ------------- UITableViewDelegate UITableViewDataSource-------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellID];
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:sCellID forIndexPath:indexPath];
    }
    cell.textLabel.text= [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 40.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
