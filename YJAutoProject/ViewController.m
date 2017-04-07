//
//  ViewController.m
//  YJAutoProject
//
//  Created by 张杰 on 16/11/29.
//  Copyright © 2016年 JayZhang. All rights reserved.
//

#import "ViewController.h"
#import "YJCustomSegementView.h"
#import "YJTextFieldView.h"
#import "YJAlbumPickerViewController.h"
#import "YJPhotoListViewController.h"
#import "PicturePreView.h"
#import "NetTool.h"
#import "JMAnimationButton.h"


#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)YJTextFieldView * fieldView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JMAnimationButton * button = [JMAnimationButton buttonWithFrame:CGRectMake(0, 0, 100, 30)];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"你好" forState:UIControlStateNormal];

    [self.view addSubview:button];
    [button startAnimation];
    
    
    [NSThread detachNewThreadWithBlock:^{
        sleep(4);
        
        [button stopAnimation];
    }];
 
    
//    NSString * sStatus = [NetTool getNetStatus];
    
    
    //
//    NSArray * array = [NSArray arrayWithObjects:@"beauty.jpg",@"timg.jpeg",@"pig.jpeg",@"bear.png",nil];
//    PicturePreView * preView = [[PicturePreView alloc]initWithFrame:self.view.bounds];
//    [preView funSetDataArray:array sourceType:ImageSourceTypeImageName];
//    [self.view addSubview:preView];
    
    // Do any additional setup after loading the view, typically from a nib.
//    _label.text = @"你是一个大好人！你是一个大好人！你是一个大好人！你是一个大好人！你是一个大好人！";
//    
//    
//    
//    NSLog(@"%lf",_labelHeight.constant);
//    
//    self.view.backgroundColor = [UIColor greenColor];
//    
//    CGRect rect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 30);
//    
//    YJCustomSegementView * view = [[YJCustomSegementView alloc]initWithFrame:rect];
    
    //    view.isSameWidthButton = NO;
//    view.titleFont = 18.f;
//    view.visibleNum = 8;
//    view.arrayTitle = @[@"狗儿",@"猪儿",@"猪儿",@"猪儿",@"猪儿",@"猪儿",@"猪儿"];
//    
//    rect.origin.y = 150;
//    rect.size.height = 100;
//    [self.view addSubview:view];
//    
//    
//    _textView = [[UITextView alloc]initWithFrame:rect];
//    _textView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:_textView];
//    
//    
//    
//    self.fieldView = [[YJTextFieldView alloc]initWithFrame:CGRectMake(0, 528, 320, 40)];
//    self.fieldView.backgroundColor = [UIColor grayColor];
//    self.fieldView.textField.placeholder = @"请写下您的评论吧!";
//    self.fieldView.textField.delegate = self;
//    [self.view addSubview:self.fieldView];
//    
//    
//    
//    rect.origin.y = 500;
//    rect.size.height = 20;
//    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame =rect;
//    [button setBackgroundColor:[UIColor redColor]];
//    [button addTarget:self action:@selector(buoooooo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    
}


//-(void)buoooooo:(UIButton *)sender{
//    
//    
//    
//    
//}
//
//
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSString *sssss = [NSString stringWithFormat:@"This is a smiley \ue415 %C face",0xE05A];
//    _label.text =sssss;
//    BOOL isContain = [self stringContainsEmoji:textField.text];
//    
//    if (isContain) {
//        NSString * string = [self changeEmojiString:textField.text];
//        
//    }
////    _textView.attributedText = [[NSAttributedString alloc]initWithString:[self stringDeleteString:textField.text] attributes:@{NSBackgroundColorAttributeName:[UIColor redColor]}];
////    
//    return YES;
//}
//
//
//-(NSString *) stringDeleteString:(NSString *)str
//{
//
//    NSMutableString *str1 = [NSMutableString stringWithString:str];
//    if (str.length < 1) {
//        return @"";
//    }
//    NSLog(@"裁剪前的长度：%ld",str.length);
//
//    for (int i = 0; i < str1.length-1; i++) {
//   
//        NSRange range1 = NSMakeRange(i, 1);
//        NSRange range2 = NSMakeRange(i+1, 1);
//        NSString * sTemp1 = [str1 substringWithRange:range1];
//        NSString * sTemp2 = [str1 substringWithRange:range2];
//        
//        NSLog(@"裁剪了的字符串变为%@：长度：%ld",str, str.length);
//        if ( [sTemp1 isEqualToString:@" "] && [sTemp2 isEqualToString:@"\n"]) { //此处可以是任何字符
//            [str1 replaceCharactersInRange:range1 withString:@""];
//            NSLog(@"index == %d遇到空格+回车",i);
//            i--;
//        }else if([sTemp1 isEqualToString:@" "] && [sTemp2 isEqualToString:@" "]){
//            [str1 replaceCharactersInRange:range1 withString:@""];
//            NSLog(@"index == %d遇到空格+空格",i);
//            i--;
//        }else if ([sTemp1 isEqualToString:@"\n"] && [sTemp2 isEqualToString:@" "]){
//            [str1 replaceCharactersInRange:range2 withString:@""];
//            NSLog(@"index == %d遇到回车+空格",i);
//
//            i--;
//        }else if ([sTemp1 isEqualToString:@"\n"] && [sTemp2 isEqualToString:@"\n"]){
//            NSLog(@"index == %d遇到回车+回车",i);
//            [str1 replaceCharactersInRange:range1 withString:@""];
//            i--;
//        }
//    }
//    
//    NSString *newstr = [NSString stringWithString:str1];
//    
//    NSLog(@"裁剪后的长度：%ld",newstr.length);
//    
//    return newstr;
//}
//
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self.view endEditing:YES];
//    
//}
//
//
//- (BOOL)stringContainsEmoji:(NSString *)string{
//    __block BOOL returnValue = NO;
//    
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//    
//    return returnValue;
//}
//
//-(NSString *)changeEmojiString:(NSString *)emojiString{
//    
//    NSString *hexstr = @"";
//    
//    for (int i=0;i< [emojiString length];i++)
//    {
//        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[emojiString characterAtIndex:i]]];
//    }
//    NSLog(@"UTF16 [%@]",hexstr);
//    
//    hexstr = @"";
//    
//    long slen = strlen([emojiString UTF8String]);
//    
//    for (int i = 0; i < slen; i++)
//    {
//        //fffffff0 去除前面六个F & 0xFF
//        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[emojiString UTF8String][i] & 0xFF ]];
//    }
//    NSLog(@"UTF8 [%@]",hexstr);
//    
//    hexstr = @"";
//    
//    if ([emojiString length] >= 2) {
//        
//        for (int i = 0; i < [emojiString length] / 2 && ([emojiString length] % 2 == 0) ; i++)
//        {
//            // 三个字节
//            if (([emojiString characterAtIndex:i*2] & 0xFF00) == 0 ) {
//                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[emojiString characterAtIndex:i*2],[emojiString characterAtIndex:i*2+1]];
//            }
//            else
//            {// 四个字节
//                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([emojiString characterAtIndex:i*2],[emojiString characterAtIndex:i*2+1])];
//            }
//            
//        }
//        NSLog(@"(unicode) [%@]",hexstr);
//    }
//    else
//    {
//        NSLog(@"(unicode) U+%1X",[emojiString characterAtIndex:0]);
//    }
//    
//    return hexstr;
//    
//}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    YJPhotoListViewController * listVC = [YJPhotoListViewController new];
    UINavigationController * nave = [[UINavigationController alloc]initWithRootViewController:listVC];
    [self presentViewController:nave animated:NO completion:^{
        YJAlbumPickerViewController * picVC = [YJAlbumPickerViewController new];
        [listVC.navigationController pushViewController:picVC animated:YES];
    }];
    

//
//    [YJProgressView showStatusWithText:@"请稍后..."];


}
@end
