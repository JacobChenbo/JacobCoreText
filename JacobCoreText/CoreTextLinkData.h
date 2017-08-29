//
//  CoreTextLinkData.h
//  JacobCoreText
//
//  Created by Jacob on 12/25/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextLinkData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSRange range;

@end
