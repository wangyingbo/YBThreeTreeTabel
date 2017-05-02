//
//  YBThreeTreeCell.h
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTreeSubModel.h"
#import "YBThreeTreeButton.h"

@protocol YBThreeTreeCellDelegate <NSObject>

@optional
- (void)thirdGradeIndex:(NSInteger)thirdGradeIndex withThirdGradeModel:(YBTreeSubModel *)thirdGradeModel;


@end

@interface YBThreeTreeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YBThreeTreeButton *bgButton;
@property (nonatomic, strong) YBThreeTreeButton *spreedButton;
@property (nonatomic, strong) UIButton *arrowButton;

@property (nonatomic, weak) id<YBThreeTreeCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;

- (void)configCellWithModel:(YBTreeSubModel *)subModel;
@end
