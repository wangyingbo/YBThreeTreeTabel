//
//  YBThreeTreeCell.m
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "YBThreeTreeCell.h"
#import "YBTreeSubCell.h"



#define CELL_H 44*VIEWLAYOUT_H
#define THREE_TREE_SUB_ID @"three_tree_sub_identifer"

extern CGFloat leftMargin_three_tree;


@interface YBThreeTreeCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSubArray;
@property (nonatomic, strong) YBTreeSubModel *subModel;
@property (nonatomic, strong) UIView *line;


@end

@implementation YBThreeTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    NSString *ID = identifier;
        YBThreeTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[YBThreeTreeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
    
    
    /**因为表格较少，可以取消表格复用*/
//    YBThreeTreeCell *cell = [[YBThreeTreeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = YBColor(200, 199, 204);
        [titleLabel addSubview:line];
        self.line = line;
        
        YBThreeTreeButton *bgButton = [[YBThreeTreeButton alloc]init];
        [self addSubview:bgButton];
        self.bgButton = bgButton;
        
        //YBThreeTreeButton *spreedButton = [[YBThreeTreeButton alloc]init];
        //[self addSubview:spreedButton];
        //self.spreedButton = spreedButton;
        
        UIButton *subButton = [[UIButton alloc]init];
        [self addSubview:subButton];
        self.arrowButton = subButton;
        
        
        
        [self creatTableView];
    }
    
    return self;
}

- (void)configCellWithModel:(YBTreeSubModel *)subModel
{
    if (subModel) {
        self.subModel = subModel;
        [self.tableView reloadData];
    }
}


- (void)creatTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CELL_H, self.frame.size.width, self.frame.size.height-CELL_H) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.userInteractionEnabled = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.scrollEnabled = NO;
    //去掉底部多余的表格线。
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[YBTreeSubCell class] forCellReuseIdentifier:THREE_TREE_SUB_ID];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(leftMargin_three_tree*2, 0, self.frame.size.width/2, CELL_H);
    
    self.tableView.frame = CGRectMake(0, CELL_H, self.frame.size.width, self.frame.size.height-CELL_H);
    
    self.line.frame = CGRectMake(0, self.titleLabel.frame.size.height - .5, self.frame.size.width, .5);
    
    self.bgButton.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    
    //self.spreedButton.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    
    CGFloat sub_button_w_h = CELL_H*2/3;
    self.arrowButton.frame = CGRectMake(self.frame.size.width - 15*VIEWLAYOUT_W - sub_button_w_h,CELL_H/2 - sub_button_w_h/2, sub_button_w_h, sub_button_w_h);
}


#pragma mark -- tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.subModel.isShow) {
        return self.subModel.sub.count;
    }else {
        return 0;
    }
    
    
//    return self.subModel.sub.count;
}


/**
 *  header的数量
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTreeSubCell *cell = [YBTreeSubCell cellWithTableView:tableView withIdentifier:THREE_TREE_SUB_ID];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark -- tableViewDelegate
/**
 *  在willDisplayCell里面处理数据能优化tableview的滑动流畅性
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTreeSubCell *subCell = (YBTreeSubCell *)cell;
    subCell.backgroundColor = YBColor(228, 228, 228);
    
    YBTreeSubModel *subModel = [self.subModel.sub objectAtIndex:indexPath.row];
    
    subCell.titleLabel.text = subModel.chapterName;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTreeSubModel *subModel = [self.subModel.sub objectAtIndex:indexPath.row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(thirdGradeIndex:withThirdGradeModel:)]) {
        [self.delegate thirdGradeIndex:indexPath.row withThirdGradeModel:subModel ];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_H;
}

@end
