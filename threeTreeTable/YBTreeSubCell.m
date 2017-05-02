//
//  YBTreeSubCell.m
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "YBTreeSubCell.h"


extern CGFloat leftMargin_three_tree;


@implementation YBTreeSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    NSString *ID = identifier;
    YBTreeSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YBTreeSubCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    /**因为表格较少，可以取消表格复用*/
    //    YBTreeSubCell *cell = [[YBTreeSubCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    
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
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(leftMargin_three_tree*3, 0, FULL_SCREEN_WIDTH/2, self.frame.size.height);
    
}
@end
