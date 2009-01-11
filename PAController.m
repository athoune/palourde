//
//  PAController.m
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import "PAController.h"
#import "Client.h"

@implementation PAController

// Helper: Load a named image, and scale it to be suitable for menu bar use.
- (NSImage *)prepareImageForMenubar:(NSString *)name
{
    NSImage *img = [NSImage imageNamed:name];
    [img setScalesWhenResized:YES];
    [img setSize:NSMakeSize(22, 22)];
    
    return img;
}

- (id) init {
    if (!(self = [super init]))
	return nil;
    paImageActive = [self prepareImageForMenubar:@"bombe__s01"];
    paImageInactive = nil;
    virus = 0;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotificationCenter *globalCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
    [globalCenter addObserver:self
	       selector:@selector(mediaMounted:)
		   name:@"NSWorkspaceDidMountNotification"
		 object:nil];
    [center addObserver:self
	       selector:@selector(oneVirus:)
		   name:PAOneVirus
		 object:nil];
    [center addObserver:self
	       selector:@selector(scanFinished:)
		   name:PAScanFinished
		 object:nil];
    return self;
}

- (void)awakeFromNib {
    // Set up status bar.
    paItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [paItem retain];
    [paItem setHighlightMode:YES];
    [paItem setImage: paImageActive];//(guessIsConfident ? sbImageActive : sbImageInactive)];
    [paItem setMenu:paMenu];
    [paItem setToolTip:@"Palourde AntiVirus"];
    [NSApp unhide];
}

- (void) oneVirus: (NSNotification *)notification{
    virus ++;
    [paItem setTitle: [NSString stringWithFormat: @"%i", virus]]; 
    NSLog(@"Virus token n°%i : %@", virus, [notification userInfo]);
}

- (void) scanFinished: (NSNotification *)notification{
    NSLog(@"The scan is done : %d ms",  [notification userInfo]);
}

- (void) mediaMounted: (NSNotification *)notification{
    NSLog(@"I'm going to scan %@", [[notification userInfo] objectForKey:@"NSDevicePath"]);
    Client *client = [[Client alloc] initWithPath:@"/tmp/clamd.socket"];
    [client asyncScan:[[notification userInfo] objectForKey:@"NSDevicePath"]];
    
}
- (void) showInStatusBar:(id)sender {
    
}

- (IBAction)runWebPage:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://admin.garambrogne.net/projets/palourde"];//[[[NSBundle mainBundle] infoDictionary] valueForKey:@"MPWebPageURL"]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)scanHome:(id)sender {
    Client *client = [[Client alloc] initWithPath:@"/tmp/clamd.socket"];
    [client autorelease];
    [client asyncScan:@"/tmp/"];
    NSLog(@"async done");
    //[client asyncScan:[@"~/" stringByExpandingTildeInPath]];
}

- (void)dealloc
{
    [paMenu release];
    [paItem release];
    [paImageActive release];
    [paImageInactive release];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
    [super dealloc];
}
@end
