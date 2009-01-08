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
	[img setSize:NSMakeSize(18, 18)];
	
	return img;
}

- (id) init {
	if (!(self = [super init]))
		return nil;
	paImageActive = [self prepareImageForMenubar:@"lapalourde"];
	paImageInactive = nil;
	paItem = nil;
	return self;
	
}

- (void)awakeFromNib {
	// Set up status bar.
	[self showInStatusBar:self];
	
	[NSApp unhide];
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
- (void)dealloc
{
	
	[super dealloc];
}
@end
