//
//  NetWorkRequestAPI.h
//  KnowledgeTree
//
//  Created by 鑫鑫 on 2017/4/12.
//  Copyright © 2017年 xinxin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  成功。
 *  @param responseObject 返回的数据。
 */
typedef void(^Succsess)(id responseObject);

/**
 *  失败。
 *  
 */
typedef void(^Failure)(NSString *errorMessage);

/*
 修改昵称
 参数
 参数名	类型    可选	备注
 nickname string	否 新昵称
 返回值
 result BOOL 否 修改结果
 resultmessage string 否 描述
 */
@interface NetWorkRequestAPI : NSObject
/*
 错题列表知识点树
 参数
 nil
 返回值
 result BOOL 否 结果
 resultmessage string 是 描述
 modelarray <ZTKKnowledgeModel>NSArray 是 知识点model
 */
+(void)requestTrainTreeWithParameter:(NSDictionary *)dic withSuccess:(Succsess)succsess andFailure:(Failure)failure;

@end
