//
//  CTDisplayView.h
//  JacobCoreText
//
//  Created by Jacob on 12/23/15.
//  Copyright © 2015 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

@protocol CTDisplayViewDelegate <NSObject>

@optional
- (void)displayViewSelectedImageName:(NSString *)name;

@end

@interface CTDisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;
@property (nonatomic, weak) id <CTDisplayViewDelegate> delegate;

@end
