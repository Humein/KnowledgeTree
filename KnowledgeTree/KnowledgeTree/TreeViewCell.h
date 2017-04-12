//
//  TreeViewCell.h
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/12.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewModel.h"
@protocol QuestionTableViewCellDelegate <NSObject>

-(void)checkClick:(TreeViewModel *)viewModel;
-(void)restartClick:(TreeViewModel *)viewModel;

@end

@interface TreeViewCell : UITableViewCell

@property(nonatomic,strong) TreeViewModel *cellViewModel;
@property(nonatomic,assign) id<QuestionTableViewCellDelegate> delegate;

-(void)refreshCellWithViewModel:(TreeViewModel *)viewModel;

+(CGFloat)heightForCell;
@end
