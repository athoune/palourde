//
//  PAController.h
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PAController : NSObject {
	IBOutlet NSMenu *paMenu;
	NSStatusItem *paItem;
	NSImage *paImageActive, *paImageInactive;
}

- (void)showInStatusBar:(id)sender;
- (void) mediaMounted: (NSNotification *)notification;
- (IBAction)runWebPage:(id)sender;
- (IBAction)scanHome:(id)sender;

@end
