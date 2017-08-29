//
//  CTFrameParserConfig.m
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init {
    if (self = [super init]) {
        _width = 200.0f;
        _fontSize = 16.0;
        _lineSpace = 8.0;
        _textColor = RGB(108, 108, 108);
    }
    
    return self;
}

@end
