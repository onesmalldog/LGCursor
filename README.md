# LGCursor
For mac os, custom cursor, put image under cursor, just like change cursor.


How to use?


@implementation AppDelegate {
    LGCursor *cursor;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    cursor = [LGCursor cursorWithNormalSize:CGSizeMake(25, 25) normalImage:[NSImage imageNamed:@"presenter-pointer_red2.png"] pressSize:CGSizeMake(15, 15) pressImage:[NSImage imageNamed:@"presenter-pointer_red.png"]];
    [cursor start];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [cursor resetNormalImage:[NSImage imageNamed:@"presenter-pointer_yellow2.png"] pressImage:[NSImage imageNamed:@"presenter-pointer_yellow.png"]];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [cursor stop];
//        CFRelease((__bridge CFTypeRef)(cursor));
//        NSLog(@"dealloc finish");
//    });
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [cursor stop];
}
@end
