//
//  PAController.h
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/GrowlApplicationBridge.h>
#import <HMBlkAppKit/HMBlkAppKit.h>

#define NOTHING 1
#define SPRAYING 2
extern NSString * const PAVirusAdded;

@class ActionController;

@interface PAController : NSObject <GrowlApplicationBridgeDelegate> {
    IBOutlet NSMenu *paMenu;
    NSStatusItem *paItem;
    NSImage *paImageActive, *paImageInactive;
    int virus, scanWorking, frame, moreVirus;
    NSDate *lastVirus;
    NSArray *animSpraying;
    NSSet *folderDownloads;
    NSSet *folderMailDownloads;
    ActionController *actionController;
    NSMutableSet *virii;
    NSMutableArray *contaminations;
    NSSound *sneeze;
    NSNotificationCenter *center;
}

- (void)showInStatusBar: (id)sender;
- (void) mediaMounted: (NSNotification *)notification;
- (void) somethingNewInFolder: (NSNotification *)notification;
- (IBAction) runWebPage: (id)sender;
- (IBAction) scanHome: (id)sender;
- (IBAction) showActionPanel: (id)sender;
- (void) asyncScan: (NSString*)thePath;
- (void) doGrowl: (NSString *)title withMessage: (NSString *)message;
- (NSArray *) contaminations;

@end
