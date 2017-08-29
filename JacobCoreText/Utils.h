//
//  Utils.h
//  JacobCoreText
//
//  Created by Jacob on 12/25/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CoreTextLinkData.h"

@interface Utils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
