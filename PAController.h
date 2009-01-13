//
//  PAController.h
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NOTHING 1
#define SPRAYING 2

@interface PAController : NSObject {
    IBOutlet NSMenu *paMenu;
    NSStatusItem *paItem;
    NSImage *paImageActive, *paImageInactive;
    int virus, scanWorking, frame;
    NSArray *animSpraying;
}

- (void)showInStatusBar:(id)sender;
- (void) mediaMounted: (NSNotification *)notification;
- (void) somethingNewInFolder: (NSNotification *)notification;
- (IBAction)runWebPage:(id)sender;
- (IBAction)scanHome:(id)sender;
- (void) asyncScan:(NSString*)thePath;


@end
