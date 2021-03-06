//
//  HtmlString.m
//  TEST_16
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HtmlString.h"
#import <Foundation/NSObjCRuntime.h>
#import "RegexKitLite.h"

@implementation HtmlString

+ (NSString *)transformString:(NSString *)originalStr
{
    
    
    NSString *text = originalStr;
    
    
    //解析http://短链接
    NSString *regex_http = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];

    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>网页链接</a>",str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
        }
    }

    //解析@
    NSString *regex_at = @"@[\\u4e00-\\u9fa5\\w\\-]+";//@的正则表达式
    NSArray *array_at = [text componentsMatchedByRegex:regex_at];
    if ([array_at count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
        for (NSString *str in array_at) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            }
        }
    }
    
    
    //解析&
    NSString *regex_dot = @"\\$\\*?[\u4e00-\u9fa5|a-zA-Z|\\d]{2,8}(\\((SH|SZ)?\\d+\\))?";//&的正则表达式
    NSArray *array_dot = [text componentsMatchedByRegex:regex_dot];
    if ([array_dot count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
        for (NSString *str in array_dot) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            }
        }
    }

    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
        }
    }

//    //解析表情
//    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";//表情的正则表达式
//    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
//    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
//    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//   // NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
//    
//    if ([array_emoji count]) {
//        for (NSString *str in array_emoji) {
//            NSRange range = [text rangeOfString:str];
//            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
//            if (i_transCharacter) {
//                //NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='12' height='12'>", path, i_transCharacter];
//                NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@>",  i_transCharacter];
//                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
//            }
//        }
//    }
    
    
    //返回转义后的字符串
    
    NSString *css =[NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "a{text-decoration: none; color:#666600;\n}"
                    "body{font-size:14; font-family:HelveticaNeueInterface-Regular; line-height:1.218; letter-spacing:0.0 ; \n}\n"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>",[text stringByReplacingOccurrencesOfString:@"查看详情</a>" withString:@""]];
    
    
    return css;
    
}


+ (NSString *)transformText:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    
    //解析http://短链接
    NSString *regex_http = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    
    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:@"网页链接"];
        }
    }
    
    return [text stringByReplacingOccurrencesOfString:@"查看详情</a>" withString:@""];

}

@end
