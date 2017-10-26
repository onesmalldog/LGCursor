//
//  LGCursor.h
//  test_mouseFrame
//
//  Created by apple on 17/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LGCursor : NSObject

@property (assign, nonatomic, readonly) BOOL isStart;

+ (instancetype)cursorWithNormalSize:(CGSize)normalSize normalImage:(NSImage *)normalImage pressSize:(CGSize)pressSize pressImage:(NSImage *)pressImage;

- (void)start;

- (void)resetNormalImage:(NSImage *)normalImage pressImage:(NSImage *)pressImage;

- (void)stop;
@end
