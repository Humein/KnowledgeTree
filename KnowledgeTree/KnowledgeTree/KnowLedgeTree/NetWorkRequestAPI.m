//
//  NetWorkRequestAPI.m
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/12.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import "NetWorkRequestAPI.h"
#import "TreeModel.h"
@implementation NetWorkRequestAPI
+(void)requestTrainTreeWithParameter:(NSDictionary *)dic withSuccess:(Succsess)succsess andFailure:(Failure)failure{

    
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Tree" ofType:@"plist"];
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
 
        id responseObject = dataDic;
        if(![responseObject isKindOfClass:[NSDictionary class]]){
            if(failure){
                failure(@"返回类型错误");
            }
            return ;
        }
        //TODO
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
    
        if (code == 1000000){
            //成功
            NSArray *dataArray = [responseObject objectForKey:@"data"];
            NSMutableArray *modelArray = [[NSMutableArray alloc]init];
            for(NSDictionary *obj in dataArray){
               TreeModel  *model = [[TreeModel alloc]initModelWithDictionary:obj];
                [modelArray addObject:model];
            }
            if(succsess){
                succsess(@{@"result":[NSNumber numberWithBool:YES],@"modelarray":modelArray});
            }
        }else{
            //失败
            NSString *message = [responseObject objectForKey:@"message"];
            if(succsess){
                succsess(@{@"result":[NSNumber numberWithBool:NO],@"resultmessage":message});
            }
        }
    }

@end
