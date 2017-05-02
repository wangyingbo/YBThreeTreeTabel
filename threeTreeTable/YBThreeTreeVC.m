//
//  YBThreeTreeVC.m
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//



#import "YBThreeTreeVC.h"
#import "YBThreeTreeCell.h"
#import "YBThreeTreeModel.h"
#import "YBTreeSubModel.h"
#import "MJExtension.h"
#import "YBThreeTreeButton.h"



#define THREE_TREE_ID @"three_tree_identifer"
#define CELL_H 44*VIEWLAYOUT_H


CGFloat leftMargin_three_tree = 15;


@interface YBThreeTreeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,YBThreeTreeCellDelegate>
{
    NSInteger _currentSection;
}
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) NSIndexPath *currentIndexPath;

@end

@implementation YBThreeTreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建tableView
    [self createTableView];
    
    [self getData];
    
    [self setNav];
    
    [self setRightButton];
}

/**
 *  设置导航栏
 */
- (void)setNav
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17.];
    label.text = @"课程";
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.barTintColor = YBColor(87, 209, 209);
}
/**
 *  添加“完成”按钮
 */
- (void)setRightButton
{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [releaseButton setTitle:@"完成" forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}

/**
 *  点击“完成”按钮
 */
- (void)rightButtonClick:(UIButton *)sender
{
}


- (void)getData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:nil];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr)
        {
            YBThreeTreeModel *model = [YBThreeTreeModel mj_objectWithKeyValues:dic];
            [mutArr addObject:model];
        }
        self.dataArray = mutArr;
        
        
        
        
        [self.tableView reloadData];
    });
}

/**
 *  创建tableView
 */
- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor = [UIColor whiteColor];
    //去掉底部多余的表格线。
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerClass:[YBThreeTreeCell class] forCellReuseIdentifier:THREE_TREE_ID];
}


#pragma mark -- tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:section];
    
    if (model.isShow) {
        
        NSArray *subArray = model.sub;
        return subArray.count;

    }else {
        return 0;
    }

}


/**
 *  header的数量
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBThreeTreeCell *cell = [YBThreeTreeCell cellWithTableView:tableView withIdentifier:THREE_TREE_ID];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.delegate = self;
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark -- tableViewDelegate
/**
 *  在willDisplayCell里面处理数据能优化tableview的滑动流畅性
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBThreeTreeCell *treeCell = (YBThreeTreeCell *)cell;
    treeCell.backgroundColor = YBColor(242, 242, 242);
    
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:indexPath.section];
    YBTreeSubModel *subModel = [model.sub objectAtIndex:indexPath.row];
    treeCell.titleLabel.text = subModel.chapterName;
    
    //为了选中
    [treeCell.bgButton addTarget:self action:@selector(subHeaderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    treeCell.bgButton.tag = indexPath.row;
    treeCell.bgButton.indexPath = indexPath;
    
//    //为了展开-可走cell的didSelected方法
//    [treeCell.spreedButton addTarget:self action:@selector(subHeaderSpreedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    treeCell.spreedButton.indexPath = indexPath;
    
    [treeCell configCellWithModel:subModel];
    
    
    if (!subModel.isShow) {
        [treeCell.arrowButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else {
        [treeCell.arrowButton setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateNormal];
    }

}

/**
 *  第二级左点击-为了选中
 */
- (void)subHeaderButtonClick:(YBThreeTreeButton *)sender
{
    NSIndexPath *indexPath = sender.indexPath;
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:indexPath.section];
    YBTreeSubModel *subModel = [model.sub objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"%@-%@",model.chapterName,subModel.chapterName];
    NSLog(@"%@",str);
    SHOW_ALTER(str);
}

/**
 *  第二级右点击-为了展开
 */
//- (void)subHeaderSpreedButtonClick:(YBThreeTreeButton *)sender
//{
//}

/**
 *  第二级右点击-为了展开
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBThreeTreeCell *treeCell = [tableView cellForRowAtIndexPath:indexPath];
    
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:indexPath.section];
    YBTreeSubModel *subModel = [model.sub objectAtIndex:indexPath.row];
    subModel.isShow = !subModel.isShow;
    
    
    
    if (subModel.isShow) {
        [treeCell.arrowButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else {
        [treeCell.arrowButton setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateNormal];
    }
    
    
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:NO];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [treeCell configCellWithModel:subModel];
    
    self.currentIndexPath = indexPath;
}

/**
 *  header的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_H;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:indexPath.section];
    YBTreeSubModel *subModel = [model.sub objectAtIndex:indexPath.row];

    
    if (subModel.isShow) {
        return CELL_H * (subModel.sub.count+1);
    }else
    {
        return CELL_H;
    }
    
//    return CELL_H * (subModel.sub.count+1);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FULL_SCREEN_WIDTH, CELL_H)];
    //bgView.backgroundColor = [UIColor grayColor];
    
    YBThreeTreeButton *bgButton = [[YBThreeTreeButton alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width/2, bgView.frame.size.height)];
    [bgButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    bgButton.tag = section;
    [bgView addSubview:bgButton];
    
    YBThreeTreeButton *spreedButton = [[YBThreeTreeButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width/2, 0, bgView.frame.size.width/2, bgView.frame.size.height)];
    [spreedButton addTarget:self action:@selector(headerSpreedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    spreedButton.tag = section;
    [bgView addSubview:spreedButton];
    
    CGFloat sub_button_w_h = CELL_H*2/3;
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(spreedButton.frame.size.width - 15*VIEWLAYOUT_W - sub_button_w_h, spreedButton.frame.size.height/2 - sub_button_w_h/2, sub_button_w_h, sub_button_w_h)];
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:section];
    if (model.isShow) {
        subButton.hidden = YES;
    }else {
        subButton.hidden = NO;
        [subButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }
    [spreedButton addSubview:subButton];
    spreedButton.subButton = subButton;
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin_three_tree, 0, FULL_SCREEN_WIDTH/2, bgView.frame.size.height)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor blackColor];
    [bgButton addSubview:textLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height - 1, bgView.frame.size.width, .5)];
    line.backgroundColor = YBColor(200, 199, 204);
    [bgView addSubview:line];
    
    
    
    textLabel.text = model.chapterName;
    
    return bgView;
}

/**
 *  第一级左点击-选中
 */
- (void)headerButtonClick:(YBThreeTreeButton *)sender
{
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:sender.tag];
    
    
    NSLog(@"%@",model.chapterName);
    SHOW_ALTER(model.chapterName);
    
}

/**
 *  第一级右点击-展开
 */
- (void)headerSpreedButtonClick:(YBThreeTreeButton *)sender
{
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:sender.tag];
    if (model.isShow) {
        sender.subButton.hidden = YES;
    }else {
        sender.subButton.hidden = NO;
        //[sender.subButton setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateNormal];
    }
    
    model.isShow = !model.isShow;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:NO];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

#pragma mark - YBThreeTreeCellDelegate
/**
 *  第三级点击-选中
 */
- (void)thirdGradeIndex:(NSInteger)thirdGradeIndex withThirdGradeModel:(YBTreeSubModel *)thirdGradeModel
{
    YBThreeTreeModel *model = [self.dataArray objectAtIndex:self.currentIndexPath.section];
    YBTreeSubModel *secondModel = [model.sub objectAtIndex:self.currentIndexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",model.chapterName,secondModel.chapterName,thirdGradeModel.chapterName];
    
    SHOW_ALTER(str);
}

@end
