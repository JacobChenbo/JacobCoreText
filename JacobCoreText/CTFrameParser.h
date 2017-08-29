//
//  CTFrameParser.h
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject

+ (NSDictionary *)attributesWidhtConfig:(CTFrameParserConfig *)config;
+ (CoreTextData *)parserContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parserTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config ;

@end
