//
//  ZPTencentIMManager.m
//  Pods-TestProject
//
//  Created by Uncel_Left on 2019/9/9.
//

#import "ZPTencentIMManager.h"
#import "TIMComm.h"
#import "TIMCallback.h"
#import "TUITextMessageCellData.h"
#import "TUIKit.h"

static ZPTencentIMManager *_instance = nil;

@interface ZPTencentIMManager ()<TUIConversationListControllerDelegagte>

@property (nonatomic, weak) id<ZPTencentIMDelegate> delegate;

@end

@implementation ZPTencentIMManager
{
    ZPIMLoginCallback _loginSuccessBlock;
    ZPIMLoginCallback _loginFailureBlock;
    ZPIMLogoutCallback _logoutSuccessBlock;
    ZPIMLogoutCallback _logoutFailureBlock;
}

#pragma mark - 单例

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZPTencentIMManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _conversationList = [[TUIConversationListController alloc] init];
        _conversationList.delegate = self;
    }
    return self;
}

/** TUIKit注册 **/
- (void)zp_registerTUIKit:(NSInteger)appid sdkAppid:(int)sdkAppid {
    
    //提出来再写一遍，加上不打印日志才可以（TUIKit里面没有暴露，只能提出来）
    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
    sdkConfig.sdkAppId = sdkAppid;
    sdkConfig.dbPath = TUIKit_DB_Path;
    sdkConfig.disableLogPrint = showIMLog;//控制台不打印日志
    sdkConfig.connListener = [TUIKit class];
    [[TIMManager sharedInstance] initSdk:sdkConfig];
    
    
    [[TUIKit sharedInstance] setupWithAppId:appid]; // sdkAppid 可以在云通信IM控制台上找到
    [self zp_globalSettingsTUIKitConfig];//全局设置TUIKitConfig（自定义UI）
}

/**
 *  登入
 *
 *  param:登入参数
 *  success:成功回调
 *  failure:失败回调
 */
- (void)zp_logingaram:(ZPTencentIMLoginParams *)login_param
              success:(ZPIMLoginCallback)success
              failure:(ZPIMLoginCallback)failure {
    _loginSuccessBlock = success;
    _loginFailureBlock = failure;
    [[TIMManager sharedInstance] login:[self zp_getIMLoginParamWithZPTencentIMLoginParams:login_param] succ:^{
        //设置苹果APNS
        TIMAPNSConfig *config = [[TIMAPNSConfig alloc] init];
        [config setOpenPush:1];
        [config setC2cSound:@"pushSound.caf"];
        [[TIMManager sharedInstance] setAPNS:config succ:nil fail:nil];
        
        self->_loginSuccessBlock(@"登入成功");
    } fail:^(int code, NSString *msg) {
        //        NSString *str = [NSString stringWithFormat:@"-----> 登入失败 : %d->%@", code, msg];
        self->_loginFailureBlock([NSString stringWithFormat:@"%d", code]);
    }];
}

/**
 *  登出
 *
 *  success:成功回调
 *  failure:失败回调
 */
- (void)zp_logoutSuccess:(ZPIMLogoutCallback)success
                 failure:(ZPIMLogoutCallback)failure {
    _logoutSuccessBlock = success;
    _logoutFailureBlock = failure;
    [[TIMManager sharedInstance] logout:^() {
        self->_logoutSuccessBlock(@"登出成功");
    } fail:^(int code, NSString * err) {
        NSString *str = [NSString stringWithFormat:@"-----> 登出失败 : %d->%@", code, err];
        self->_logoutFailureBlock(str);
    }];
}

/** 转换获取登陆参数 **/
- (TIMLoginParam *)zp_getIMLoginParamWithZPTencentIMLoginParams:(ZPTencentIMLoginParams *)zpIMLoginParams {
    TIMLoginParam *login_param = [[TIMLoginParam alloc] init];
    // identifier 为用户名
    login_param.identifier = zpIMLoginParams.identifier;
    //userSig 为用户登录凭证
    login_param.userSig = zpIMLoginParams.userSig;
    //appidAt3rd 在私有帐号情况下，填写与 SDKAppID 一样
    login_param.appidAt3rd = zpIMLoginParams.appidAt3rd;
    
    return login_param;
}

/** 全局设置TUIKitConfig（自定义UI） **/
- (void)zp_globalSettingsTUIKitConfig {
    
    TUIKitConfig *config = [TUIKitConfig defaultConfig];
    // 修改默认头像
    config.defaultAvatarImage = [UIImage imageNamed:@"mine_head"];
    // 修改头像类型为圆角矩形，圆角大小为5
    config.avatarType = TAvatarTypeRadiusCorner;
    config.avatarCornerRadius = 3.f;
    
    TUITextMessageCellData.outgoingTextColor = [UIColor whiteColor];//输出字颜色
    TUITextMessageCellData.outgoingTextFont = [UIFont systemFontOfSize:16];//输出字号
    
    TUITextMessageCellData.incommingTextColor = [UIColor blackColor];//输入字颜色
    TUITextMessageCellData.incommingTextFont = [UIFont systemFontOfSize:16];//输入字号
    
    // 设置发送气泡，包括普通状态和选中状态；设置接收的方法类似
    //发出的气泡
    [TUIBubbleMessageCellData setOutgoingBubble:[[UIImage imageNamed:@"chat_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,20,22,20}") resizingMode:UIImageResizingModeStretch]];
    //接收的气泡
    [TUIBubbleMessageCellData setIncommingBubble:[[UIImage imageNamed:@"chat_bg_1"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{30,20,22,20}") resizingMode:UIImageResizingModeStretch]];
    
    
}

/** 会话列表点击事件 **/
- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation
{
    //打开聊天界面
    [self.delegate zp_openChatInterfaceWithConversation:conversation vc:conversationController];
}

/** 获取当前未读消息数量 **/
- (int)zp_getUnreadMessagesNumWithConversation:(TIMConversation *)conversation {
    return [conversation getUnReadMessageNum];
}

/** 获取会话列表 **/
- (NSArray *)zp_getConversationList {
    return [[TIMManager sharedInstance] getConversationList];
}

/** 设置用户信息 **/
- (void)zp_setUserProfile:(NSDictionary<NSString *, id> *)values {
    [[TIMFriendshipManager sharedInstance] modifySelfProfile:values
                                                        succ:^{
                                                            NSLog(@"设置成功");
                                                        } fail:nil];
}

/** 获取未读计数 **/
- (int)getUnreadCount {
    int unReadCount = 0;
    NSArray *convs = [self zp_getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_C2C){
            unReadCount += [[ZPTencentIMManager manager] zp_getUnreadMessagesNumWithConversation:conv];
        }
    }
    return unReadCount;
}

@end
