//
//  ZPTencentIMLoginParams.m
//  Pods-TestProject
//
//  Created by Uncel_Left on 2019/9/9.
//

#import "ZPTencentIMLoginParams.h"

@implementation ZPTencentIMLoginParams
{
    NSDictionary *_param;
}

- (instancetype)initWithParam:(id)param {
    if (self = [super init]) {
        _param = param;
    }
    return self;
}

+ (instancetype)param:(id)param {
    return [[ZPTencentIMLoginParams alloc] initWithParam:param];
}

/** params */
- (NSString *)identifier {
    return _param[@"identifier"];
}
- (NSString *)userSig {
    return _param[@"userSig"];
}
- (NSString *)appidAt3rd {
    return _param[@"appidAt3rd"];
}

@end
