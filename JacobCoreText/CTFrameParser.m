//
//  CTFrameParser.m
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import "CTFrameParser.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@implementation CTFrameParser

+ (NSDictionary *)attributesWidhtConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {{kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace}, {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace}, {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}};
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

+ (CoreTextData *)parserContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
//    NSDictionary *attributes = [self attributesWidhtConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithAttributedString:content];
    
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    // 获得要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *coreText = [[CoreTextData alloc] init];
    coreText.ctFrame = frame;
    coreText.height = textHeight;
    
    return coreText;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (CoreTextData *)parserTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *coreText = [self parserContent:content config:config];
    coreText.imageArray = imageArray;
    coreText.linkArray = linkArray;
    
    return coreText;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in array) {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionory:dic config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dic[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parseImageDataFromDictionary:dic config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"link"]) {
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionory:dic config:config];
                    [result appendAttributedString:as];
                    
                    // 创建 coreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dic[@"content"];
                    linkData.url = dic[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    
    return result;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionory:(NSDictionary *)dic config:(CTFrameParserConfig *)config {
    NSMutableDictionary *attributes = (NSMutableDictionary *)[self attributesWidhtConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dic[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    // set font size
    CGFloat fontSize = [dic[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dic[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}

+ (NSAttributedString *)parseImageDataFromDictionary:(NSDictionary *)dic config:(CTFrameParserConfig *)config {
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallback;
    callBacks.getDescent = descentCallback;
    callBacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dic);
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWidhtConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    return space;
}

static CGFloat ascentCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref) {
    return 0;
}

static CGFloat widthCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

@end
