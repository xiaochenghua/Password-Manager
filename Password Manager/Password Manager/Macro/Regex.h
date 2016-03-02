//
//  Regex.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/22.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#ifndef Regex_h
#define Regex_h

//  手机号验证
#define phoneNumberRegex @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"

//  邮箱地址验证
#define emailRegex       @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$"

#endif /* Regex_h */
