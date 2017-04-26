//
//  CreatTreeView.m
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/25.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import "CreatTreeView.h"
#import "TreeModel.h"
#import "TreeViewCell.h"
@interface CreatTreeView()<UITableViewDelegate,UITableViewDataSource,QuestionTableViewCellDelegate>
{
    
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSMutableArray *dataSource;
@property(nonatomic,copy) NSMutableArray *cellViewModelArray;
@property(nonatomic,copy) NSMutableArray *levelOneModelArray;
@property (nonatomic) BOOL                  sectionFirstLoad;
@end

@implementation CreatTreeView
#pragma mark - lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorColor = UICOLOR_RGB_Alpha(0xdcdcdc, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UICOLOR_RGB_Alpha(0xffffff, 1);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView reloadData];
    }
    return _tableView;
}

#pragma mark - InitMethod
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSMutableArray<NSMutableArray *> *)dataSource cellViewModelArray:(NSMutableArray<NSMutableArray *> *)cellViewModelArray  levelOneModelArray:(NSMutableArray<NSMutableArray *> *)levelOneModelArray{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _dataSource= [NSMutableArray arrayWithArray:dataSource];
        _cellViewModelArray = [NSMutableArray arrayWithArray:cellViewModelArray];
        _levelOneModelArray = [NSMutableArray arrayWithArray:levelOneModelArray];
        [self loadData];
        [self addSubviews];
    }
    return self;
}
#pragma mark - add subviews

- (void)addSubviews {
    
    [self addSubview:self.tableView];
}

#pragma mark - layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
    [_tableView reloadData];
}

#pragma mark - load data

- (void)loadData {

}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellViewModelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TreeViewCell";
    TreeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TreeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    TreeViewModel *cellViewModel = [self.cellViewModelArray objectAtIndex:indexPath.row];
    [cell refreshCellWithViewModel:cellViewModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TreeViewCell heightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeViewModel *cellViewModel = [self.cellViewModelArray objectAtIndex:indexPath.row];
    
    if(cellViewModel.openstate == ErrorQuestionCellClose){
        cellViewModel.openstate = ErrorQuestionCellOpen;
        NSArray *childCellNode = [self generateCellViewModelArrayWithKnowledgeModelArray:cellViewModel.knowledgeModel.childrenKnowledgeModelArray];
        [self.cellViewModelArray insertObjects:childCellNode atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, childCellNode.count)]];
        NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
        for(NSInteger i = indexPath.row+1 ; i <= indexPath.row + childCellNode.count ; i++){
            NSIndexPath *obj = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:obj];
        }
        [self setCellIndex];
        [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }else{
        cellViewModel.openstate = ErrorQuestionCellClose;
        NSArray *showingChildCellNode = [self allShowingChildNodeWithCellViewModel:cellViewModel];
        [self.cellViewModelArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, showingChildCellNode.count)]];
        NSMutableArray *indexPathArray = [[NSMutableArray alloc]init];
        for(NSInteger i = indexPath.row+1 ; i <= indexPath.row + showingChildCellNode.count ; i++){
            NSIndexPath *obj = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:obj];
        }
        [self setCellIndex];
        [_tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    self.sectionFirstLoad = YES;
}
#pragma mark - Cell Animation
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    CATransform3D  transform;
    //    transform = CATransform3DMakeRotation((CGFloat)((90.0 * M_PI) / 180.0), 0.0, 0.7, 0.4);
    //    transform.m34 = 1.0/-600;
    //    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    cell.layer.shadowOffset = CGSizeMake(10, 10);
    //    cell.alpha = 0;
    //    cell.layer.transform = transform;
    //    cell.layer.anchorPoint = CGPointMake(0, 0.5);//锚点
    //    if(cell.layer.position.x != 0){
    //        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    //    }
    //    [UIView beginAnimations:@"transform" context:NULL];
    //    [UIView setAnimationDuration:0.8];
    //    cell.layer.transform = CATransform3DIdentity;
    //    cell.alpha = 1;
    //    cell.layer.shadowOffset = CGSizeMake(0, 0);
    //    [UIView commitAnimations];
    
    //    if (self.sectionFirstLoad == NO) {
    //        //设置Cell的动画效果为3D效果
    //        //设置x和y的初始值为0.1；
    //        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //        //x和y的最终值为1
    //        [UIView animateWithDuration:1 animations:^{
    //            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    //        }];
    //
    //    }else{
    //
    //        return;
    //    }
    
}

- (NSArray *)generateCellViewModelArrayWithKnowledgeModelArray:(NSArray *)modelArray{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for(TreeModel *model in modelArray){
        TreeViewModel *cellViewModel = [[TreeViewModel alloc]init];
        cellViewModel.knowledgeModel = model;
        cellViewModel.level = [model.level integerValue];
        cellViewModel.openstate = ErrorQuestionCellClose;
        [mArray addObject:cellViewModel];
    }
    return mArray;
}

-(void)setCellIndex{
    for(TreeViewModel *cellModel in self.cellViewModelArray){
        NSInteger index = [self.cellViewModelArray indexOfObject:cellModel];
        TreeViewModel *nextCellModel = nil;
        if(index + 1 < self.cellViewModelArray.count){
            nextCellModel = [self.cellViewModelArray objectAtIndex:index+1];
        }
        if([self isLevelOneModelWithCellViewModel:cellModel]){
            cellModel.index = ErrorQuestionCellIndexTop;
        }else if([[self.cellViewModelArray lastObject] isEqual:cellModel]){
            cellModel.index = ErrorQuestionCellIndexBottom;
        }else if(nextCellModel && [self isLevelOneModelWithCellViewModel:nextCellModel]){
            cellModel.index = ErrorQuestionCellIndexBottom;
        }else{
            cellModel.index = ErrorQuestionCellIndexCenter;
        }
    }
}

-(NSArray *)allShowingChildNodeWithCellViewModel:(TreeViewModel *)cellViewModel{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    NSArray *knowledgeModelArray = [TreeModel allChildNodeWithKnowledgeModel:cellViewModel.knowledgeModel];
    for(TreeModel *knowledgeMdeol in knowledgeModelArray){
        for(TreeViewModel *obj in self.cellViewModelArray){
            if([knowledgeMdeol.knowledgeID isEqualToString:obj.knowledgeModel.knowledgeID]){
                [mArray addObject:obj];
            }
        }
    }
    return mArray;
}

-(BOOL)isLevelOneModelWithCellViewModel:(TreeViewModel *)cellModel{
    return [self.levelOneModelArray containsObject:cellModel.knowledgeModel];
}

@end
