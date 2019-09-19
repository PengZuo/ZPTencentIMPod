//
//  ZPTencentIMLoginParams.h
//  Pods-TestProject
//
//  Created by Uncel_Left on 2019/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPTencentIMLoginParams : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *identifier;
/** 用户登录凭证 */
@property (nonatomic, copy) NSString *userSig;
/** appidAt3rd 在私有帐号情况下，填写与 SDKAppID 一样 */
@property (nonatomic, copy) NSString *appidAt3rd;

+ (instancetype)param:(id)param;

@end

NS_ASSUME_NONNULL_END
