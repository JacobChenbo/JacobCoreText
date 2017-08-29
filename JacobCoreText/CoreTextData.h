//
//  CoreTextData.h
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *linkArray;

@end
