//
//  SQL.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#ifndef SQL_h
#define SQL_h

//  创建表
#define kCreateString \
@"CREATE TABLE IF NOT EXISTS t_password_item (\
item_id INTEGER PRIMARY KEY AUTOINCREMENT, \
site_name TEXT NOT NULL, \
user_name TEXT NOT NULL, \
mobile TEXT, \
email TEXT, \
password TEXT NOT NULL);"

//  插入
#define kInsertString \
@"INSERT INTO t_password_item (site_name, user_name, mobile, email, password) VALUES (?, ?, ?, ?, ?)"

//  更新
#define kUpdateString \
@"UPDATE t_password_item SET ?=? WHERE item_id=?"

//  删除
#define kDeleteString \
@"DELETE FROM t_password_item WHERE item_id=%ld"

//  查找数据
#define kQueryString \
@"SELECT * FROM t_password_item WHERE INSTR(site_name,?)>0 ORDER BY site_name ASC"
//@"SELECT * FROM t_password_item WHERE site_name=?"

#define kQueryAllString \
@"SELECT * FROM t_password_item"

#define kQueryCountString \
@"SELECT COUNT(*) FROM t_password_item"

#endif /* SQL_h */
