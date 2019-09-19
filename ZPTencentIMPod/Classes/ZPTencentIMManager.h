//
//  ZPTencentIMManager.h
//  Pods-TestProject
//
//  Created by Uncel_Left on 2019/9/9.
//

#import <Foundation/Foundation.h>
#import "ZPTencentIMLoginParams.h"
#import "ImSDK.h"
#import "TUIConversationListController.h"

#define showIMLog 1

@protocol ZPTencentIMDelegate<NSObject>
/**
 打开聊天界面
 
 @param conversation 信息
 @param vc vc
 */
- (void)zp_openChatInterfaceWithConversation:(TUIConversationCell *_Nullable)conversation vc:(UIViewController *_Nullable)vc;
@end

typedef void(^ZPIMLoginCallback)(NSString * _Nullable msg);
typedef void(^ZPIMLogoutCallback)(NSString * _Nullable msg);

NS_ASSUME_NONNULL_BEGIN

@interface ZPTencentIMManager : NSObject

@property (nonatomic, strong) TUIConversationListController *conversationList;

/**
 *  实例化
 */
+ (instancetype)manager;

/**
 *  TUIKit注册
 *  sdkAppid:appId
 */
- (void)zp_registerTUIKit:(NSInteger)appid sdkAppid:(int)sdkAppid;

/**
 *  登入
 *
 *  param:登入参数
 *  success:成功回调
 *  failure:失败回调
 */
- (void)zp_logingaram:(ZPTencentIMLoginParams *)login_param
              success:(ZPIMLoginCallback)success
              failure:(ZPIMLoginCallback)failure;

/**
 *  登出
 *
 *  success:成功回调
 *  failure:失败回调
 */
- (void)zp_logoutSuccess:(ZPIMLogoutCallback)success
                 failure:(ZPIMLogoutCallback)failure;

/**
 转换获取登陆参数
 
 @param zpIMLoginParams 登陆参数
 @return 腾讯云通讯登陆参数
 */
- (TIMLoginParam *)zp_getIMLoginParamWithZPTencentIMLoginParams:(ZPTencentIMLoginParams *)zpIMLoginParams;


/**
 获取当前未读消息数量
 
 @param conversation 会话
 @return 未读消息数量
 */
- (int)zp_getUnreadMessagesNumWithConversation:(TIMConversation *)conversation;

/**
 获取会话列表
 
 @return 会话列表数组
 */
- (NSArray *)zp_getConversationList;


/**
 设置用户信息
 
 @param values @{TIMProfileTypeKey_Nick:[ZMUserInfo cache].nickName} TIMProfileTypeKey_Nick昵称 TIMProfileTypeKey_FaceUrl头像
 */
- (void)zp_setUserProfile:(NSDictionary<NSString *, id> *)values;

/**
 获取未读计数(列表的未读数)
 
 @return 未读消息数
 */
- (int)getUnreadCount;

@end

NS_ASSUME_NONNULL_END
