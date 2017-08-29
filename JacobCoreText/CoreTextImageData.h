//
//  CoreTextImageData.h
//  JacobCoreText
//
//  Created by Jacob on 12/24/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger position;

// 此坐标是CoreText的坐标系， 而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end
