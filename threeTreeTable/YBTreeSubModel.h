//
//  YBTreeSubModel.h
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBTreeSubModel : NSObject

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) NSString *chapterID;
@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSArray *sub;

@end
