//
//  LGCursor.m
//  test_mouseFrame
//
//  Created by apple on 17/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LGCursor.h"

#define MarginX 0//-2
#define MarginY 0//2

@implementation LGCursor {
    NSWindow *win;
    CGSize nSize;
    CGSize pSize;
    CGSize currentSize;
    id globalMonitor;
    id localMonitor;
    __weak NSImageView *imageV;
    NSImage *nImage;
    NSImage *pImage;
}
+ (instancetype)cursorWithNormalSize:(CGSize)normalSize normalImage:(NSImage *)normalImage pressSize:(CGSize)pressSize pressImage:(NSImage *)pressImage {
    return [[self alloc] initWithNormalSize:normalSize normalImage:normalImage pressSize:pressSize pressImage:pressImage];
}

- (void)resetNormalImage:(NSImage *)normalImage pressImage:(NSImage *)pressImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        nImage = normalImage;
        pImage = pressImage;
        imageV.hidden = NO;
        if (CGSizeEqualToSize(nSize, currentSize)) {
            imageV.image = normalImage;
        }
        else {
            imageV.image = pressImage;
        }
    });
}
- (void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isStart) {
            return;
        }
        [[NSWorkspace sharedWorkspace].notificationCenter removeObserver:self];
        [NSEvent removeMonitor:globalMonitor];
        globalMonitor = NULL;
        [NSEvent removeMonitor:localMonitor];
        localMonitor = NULL;
        imageV.hidden = YES;
        _isStart = NO;
    });
}
- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isStart = YES;
        [[NSWorkspace sharedWorkspace].notificationCenter addObserver:self selector:@selector(activeSpaceDidChange:) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
        
        globalMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskMouseMoved | NSEventMaskLeftMouseDown | NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDragged | NSEventMaskRightMouseDragged | NSEventMaskRightMouseUp | NSEventMaskRightMouseDown handler:^(NSEvent * _Nonnull event) {
            if (!_isStart) {
                return;
            }
            if ((event.type == NSEventTypeMouseMoved) || (event.type == NSEventTypeLeftMouseDragged) || (event.type == NSEventTypeRightMouseDragged)) {
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
            }
            else if ((event.type == NSEventTypeLeftMouseDown) || (event.type == NSEventTypeRightMouseDown)) {
                imageV.image = pImage;
                currentSize = pSize;
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
                imageV.frame = win.contentView.bounds;
            }
            else if ((event.type == NSEventTypeLeftMouseUp) || (event.type == NSEventTypeRightMouseUp)) {
                imageV.image = nImage;
                currentSize = nSize;
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
                imageV.frame = win.contentView.bounds;
            }
        }];
        
        localMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved | NSEventMaskLeftMouseDown | NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDragged | NSEventMaskRightMouseDragged | NSEventMaskRightMouseUp | NSEventMaskRightMouseDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
            
            if (!_isStart) {
                return NULL;
            }
            
            if ((event.type == NSEventTypeMouseMoved) || (event.type == NSEventTypeLeftMouseDragged) || (event.type == NSEventTypeRightMouseDragged)) {
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
            }
            else if ((event.type == NSEventTypeLeftMouseDown) || (event.type == NSEventTypeRightMouseDown)) {
                imageV.image = pImage;
                currentSize = pSize;
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
                imageV.frame = win.contentView.bounds;
            }
            else if ((event.type == NSEventTypeLeftMouseUp) || (event.type == NSEventTypeRightMouseUp)) {
                imageV.image = nImage;
                currentSize = nSize;
                [win setFrame:CGRectMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY, currentSize.width, currentSize.height) display:YES];
                imageV.frame = win.contentView.bounds;
                
            }
            return event;
        }];
    });
}

- (instancetype)initWithNormalSize:(CGSize)normalSize normalImage:(NSImage *)normalImage pressSize:(CGSize)pressSize pressImage:(NSImage *)pressImage {
    if (self = [super init]) {
        
        if (CGSizeEqualToSize(normalSize, CGSizeZero)) {
            normalSize = CGSizeMake(25, 25);
        }
        if (CGSizeEqualToSize(pressSize, CGSizeZero)) {
            pressSize = CGSizeMake(15, 15);
        }
        nSize = normalSize;
        pSize = pressSize;
        nImage = normalImage;
        pImage = pressImage;
        currentSize = normalSize;
        
        win = [[NSWindow alloc] initWithContentRect:CGRectMake([NSEvent mouseLocation].x-nSize.width*0.5+MarginX, [NSEvent mouseLocation].y-nSize.height*0.5+MarginY, nSize.width, nSize.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES screen:[NSScreen mainScreen]];
        win.backgroundColor = [NSColor clearColor];//[[NSColor greenColor] colorWithAlphaComponent:0.5];
        [win setIsVisible:YES];
        [win setLevel:10001];
        win.ignoresMouseEvents = YES;
        
        NSImageView *iv = [[NSImageView alloc] initWithFrame:win.contentView.bounds];
        iv.layer.backgroundColor = [NSColor clearColor].CGColor;
        iv.image = normalImage;
        [win.contentView addSubview:iv];
        imageV = iv;
    }
    return self;
}
- (void)activeSpaceDidChange:(id)sender {
    [win setIsVisible:NO];
    [win setFrameOrigin:CGPointMake([NSEvent mouseLocation].x-currentSize.width*0.5+MarginX, [NSEvent mouseLocation].y-currentSize.height*0.5+MarginY)];
    [win setIsVisible:YES];
}
- (void)dealloc {
    NSLog(@"dealloc");
    
    if (_isStart) {
        [self stop];
    }
}
@end
