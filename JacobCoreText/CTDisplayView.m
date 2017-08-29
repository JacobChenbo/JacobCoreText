
//
//  CTDisplayView.m
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"
#import "Utils.h"

@implementation CTDisplayView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupEvents];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupEvents];
    }
    
    return self;
}

- (void)setupEvents {
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (void)userTap:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    for (CoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系，因为imageData中得坐标是CoreText的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        if (CGRectContainsPoint(rect, point)) {
            // 在这里处理点击后的逻辑
            NSLog(@"%@", imageData.name);
            if ([self.delegate respondsToSelector:@selector(displayViewSelectedImageName:)]) {
                [self.delegate displayViewSelectedImageName:imageData.name];
            }
            
            break;
        }
    }
    
    CoreTextLinkData *linkData = [Utils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"%@", linkData.url);
        return;
    }
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
        
        for (CoreTextImageData *imageData in self.data.imageArray) {
            UIImage *image = [UIImage imageNamed:imageData.name];
            if (image) {
                CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
            }
        }
    }
}

@end
