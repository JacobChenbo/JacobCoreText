//
//  ViewController.m
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
#import "UIView+frameAdjust.h"
#import "CTFrameParser.h"
#import "ImageViewController.h"

@interface ViewController ()<CTDisplayViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(50, 100, 300, 0)];
    view.delegate = self;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = view.width;
    config.lineSpace = 5;

//    NSDictionary *attributes = [CTFrameParser attributesWidhtConfig:config];
//    NSString *content = @"按照以上原则，我们123将‘CTDisplayView’ 中得部分内容拆开 \n\n 将前几个字变色";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 6)];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(2, 2)];
    
//    CoreTextData *data = [CTFrameParser parserContent:attributedString config:config];
//    view.data = data;
//    view.height = data.height;

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parserTemplateFile:path config:config];
    view.data = data;
    view.height = data.height;

}

- (void)displayViewSelectedImageName:(NSString *)name {
    ImageViewController *imageViewController = [[ImageViewController alloc] init];
    imageViewController.name = name;
    [self.navigationController pushViewController:imageViewController animated:YES];
}

@end
