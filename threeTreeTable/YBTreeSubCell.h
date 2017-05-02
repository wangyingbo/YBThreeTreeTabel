//
//  YBTreeSubCell.h
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBTreeSubCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;
@end
