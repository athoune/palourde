//
//  PAController.m
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import "PAController.h"


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
	paItem = nil;
	return self;
	
}

- (void)awakeFromNib {
	// Set up status bar.
	[self showInStatusBar:self];
	
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
														   selector:@selector(mediaMounted:)
															   name:@"NSWorkspaceDidMountNotification"
															 object:nil];
	
	[NSApp unhide];
}

-(void) mediaMounted: (NSNotification *)notification{
	NSLog(@"mount : %@", notification);

}
- (void)showInStatusBar:(id)sender
{
	if (paItem) {
		// Already there? Rebuild it anyway.
		[[NSStatusBar systemStatusBar] removeStatusItem:paItem];
		[paItem release];
	}
	
	paItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[paItem retain];
	[paItem setHighlightMode:YES];
	[paItem setImage: paImageActive];//(guessIsConfident ? sbImageActive : sbImageInactive)];
	[paItem setMenu:paMenu];
}

- (IBAction)runWebPage:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"https://admin.garambrogne.net/projets/palourde"];//[[[NSBundle mainBundle] infoDictionary] valueForKey:@"MPWebPageURL"]];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)dealloc
{
	
	[super dealloc];
}
@end
