//
//  PAController.m
//  Palourde
//
//  Created by Mathieu Lecarme on 08/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import "PAController.h"
#import "ClamavClient.h"
#import "UKKQueue.h"

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
    scanWorking = 0;
    frame = 0;
    animSpraying = [[NSArray arrayWithObjects:
		    [self prepareImageForMenubar:@"bombe__s01"],
		    [self prepareImageForMenubar:@"bombe__s02"],
		    [self prepareImageForMenubar:@"bombe__s03"],
		    [self prepareImageForMenubar:@"bombe__s04"],
		    nil]retain];
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
    UKKQueue* kqueue = [UKKQueue sharedFileWatcher];
    [kqueue addPathToQueue:[@"~/Downloads/" stringByExpandingTildeInPath]];
    [kqueue addPathToQueue:[@"~/Library/Mail Downloads/" stringByExpandingTildeInPath]];
    [globalCenter addObserver:self
		     selector:@selector(somethingNewInFolder:)
			 name:UKFileWatcherWriteNotification
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
    scanWorking --;
    NSLog(@"The scan is done : %f ms",  [notification userInfo]);
    NSLog(@"%i scan is still alive", scanWorking);
}

- (void) mediaMounted: (NSNotification *)notification{
    NSLog(@"I'm going to scan %@", [[notification userInfo] objectForKey:@"NSDevicePath"]);
    [self asyncScan:[[notification userInfo] objectForKey:@"NSDevicePath"]];
}

- (void) somethingNewInFolder: (NSNotification *)notification{
    NSLog(@"A new folder is going to be scanned: %@", [[notification userInfo] objectForKey:@"path"]);
}

- (void) showInStatusBar:(id)sender {
    
}

- (void) nextFrameSpraying {
    if(scanWorking == 0) {
	frame = 0;
    }
    [paItem setImage:[animSpraying objectAtIndex:frame]];
    if(scanWorking > 0) {
	frame ++;
	if(frame > 3) {
	    frame = 0;
	}
	[NSTimer scheduledTimerWithTimeInterval:0.1
		target:self
		selector:@selector(nextFrameSpraying)
		userInfo:nil
		repeats:NO];
    }
}

- (IBAction)runWebPage:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://admin.garambrogne.net/projets/palourde"];//[[[NSBundle mainBundle] infoDictionary] valueForKey:@"MPWebPageURL"]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)scanHome:(id)sender {
	[self 
		performSelectorOnMainThread:@selector(asyncScan:)
		withObject:[@"~/" stringByExpandingTildeInPath]
		waitUntilDone:false];
	//@"/tmp/"
    //[client asyncScan:[@"~/" stringByExpandingTildeInPath]];
}

-(void) asyncScan:(NSString*)thePath {
	[self retain];
	scanWorking ++;
    [self nextFrameSpraying];
	[NSThread detachNewThreadSelector:@selector(processAsyncScan:)
							 toTarget:self
						   withObject:[thePath retain]];
}

-(void) processAsyncScan:(NSString*)thePath {
	[thePath retain];
	NSAutoreleasePool *myAutoreleasePool =[[NSAutoreleasePool alloc] init];
	NSLog(@"Async scan started");
	ClamavClient *client = [[ClamavClient alloc] initWithPath:@"/tmp/clamd.socket"];
	[client contscan:thePath];
	//[client release];
	//[NSAutoreleasePool showPools];
	[myAutoreleasePool drain];
    NSLog(@"async scan is done");
} 

- (void)dealloc
{
    [paMenu release];
    [paItem release];
    [paImageActive release];
    [paImageInactive release];
    [animSpraying release];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
    [super dealloc];
}
@end
