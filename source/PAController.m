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
#import <Growl/GrowlApplicationBridge.h>
#import "ActionController.h"
#import <crt_externs.h>
#import "Contamination.h"

#import <HMBlkAppKit/HMBlkAppKit.h>

NSString * const PAVirusAdded = @"PAVirusAdded";

@implementation PAController

// Helper: Load a named image, and scale it to be suitable for menu bar use.
- (NSImage *)prepareImageForMenubar:(NSString *)name {
	NSImage *img = [NSImage imageNamed:name];
	[img setScalesWhenResized:YES];
	[img setSize:NSMakeSize(22, 22)];
	return img;
}

- (id) init {
	if (!(self = [super init]))
		return nil;

	[GrowlApplicationBridge setGrowlDelegate:self];

	paImageActive = [self prepareImageForMenubar:@"bombe__s01"];
	paImageInactive = nil;
	virus = 0;
	scanWorking = 0;
	frame = 0;
    contaminations = [[NSMutableArray alloc]init];
	animSpraying = [[NSArray arrayWithObjects:
	[self prepareImageForMenubar:@"bombe__s01"],
		[self prepareImageForMenubar:@"bombe__s02"],
		[self prepareImageForMenubar:@"bombe__s03"],
		[self prepareImageForMenubar:@"bombe__s04"],
		nil]retain];
	center = [NSNotificationCenter defaultCenter];
	NSNotificationCenter *globalCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
	//NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
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
	folderDownloads = [[NSMutableSet alloc] initWithCapacity:16];
	folderMailDownloads = [[NSMutableSet alloc] initWithCapacity:16];
    
	//argv parsing
	char **argv = *_NSGetArgv();

	for (int i = 0; argv[i] != NULL; ++i) {
		printf("%15s [%02d] = '%s'\n", "_NSGetArgv()", i, argv[i]);
		if(strcmp("-panel", argv[i])){
			[self showActionPanel:nil];
		}
	}
	return self;
}

- (void)awakeFromNib {
		// Set up status bar.
	paItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[paItem retain];
	[paItem setHighlightMode:YES];
	[paItem setImage: paImageActive];//(guessIsConfident ? sbImageActive : sbImageInactive)];
	[paItem setMenu:paMenu];
	[paItem setToolTip:NSLocalizedString(@"Palourde AntiVirus", @"Application name")];
	[NSApp unhide];
}

- (IBAction)showActionPanel: (id)sender {
	if(! actionController) {
		actionController = [[ActionController alloc] initWithMainController:self];
		NSLog(@"affichage de %@", actionController);
		[actionController showWindow:self];
	}
	[actionController showWindow:self];
}

- (void) error: (NSNotification *)notification {
	[self doGrowl:NSLocalizedString(@"Error", @"Popup title") withMessage: [NSString stringWithFormat:@"%@",[notification userInfo]]];
}

- (void) oneVirus: (NSNotification *)notification {
	virus ++;
	[paItem setTitle: [NSString stringWithFormat: @"%i", virus]]; 
	NSLog(@"Virus token n°%i : %@", virus, [notification userInfo]);
	[virii addObject:[[notification userInfo] objectForKey:@"virus"]];
        [contaminations addObject:[[Contamination alloc] initWithPath:[[notification userInfo] objectForKey:@"file"] andVirus:[[notification userInfo] objectForKey:@"virus"]]];
	[center postNotificationName: PAVirusAdded object:nil];
	if(sneeze == nil) {
	    sneeze = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sneeze" ofType:@"wav"] byReference:NO];
	    [sneeze play];
	    [sneeze release];
	    sneeze = nil;
	}
	[self doGrowl:NSLocalizedString(@"Un virus!", @"Popup title") withMessage:
	[[NSString alloc] initWithFormat:NSLocalizedString(@"Le virus %@ a été trouvé dans le fichier %@",""), 
		[[notification userInfo] objectForKey:@"virus"],
		[[notification userInfo] objectForKey:@"file"]]];
}

- (void) scanFinished: (NSNotification *)notification{
	scanWorking --;
	NSLog(@"The scan is done : %f ms",  [notification userInfo]);
	NSLog(@"%i scan is still alive", scanWorking);
}

- (void) mediaMounted: (NSNotification *)notification {
	NSLog(@"I'm going to scan %@", [[notification userInfo] objectForKey:@"NSDevicePath"]);
	[self asyncScan:[[notification userInfo] objectForKey:@"NSDevicePath"]];
}

- (void) somethingNewInFolder: (NSNotification *)notification {
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

- (IBAction)runWebPage:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://palourde.net/"];//[[[NSBundle mainBundle] infoDictionary] valueForKey:@"MPWebPageURL"]];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)scanHome:(id)sender {
	[self 
		performSelectorOnMainThread:@selector(asyncScan:)
		withObject:[@"~/Developpement/Cocoa/palourde/palourde" stringByExpandingTildeInPath]
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

- (void)doGrowl:(NSString *)title withMessage:(NSString *)message {
	float pri = 0;

	if ([title isEqualToString:@"Failure"])
		pri = 1;

	[GrowlApplicationBridge notifyWithTitle:title
		description:message
		notificationName:title
		iconData:nil
		priority:pri
		isSticky:NO
		clickContext:nil];
}

- (NSDictionary *) registrationDictionaryForGrowl
{
	NSArray *notifications = [NSArray arrayWithObjects:
	@"Un virus!",
		nil];

	return [NSDictionary dictionaryWithObjectsAndKeys:
	notifications, GROWL_NOTIFICATIONS_ALL,
		notifications, GROWL_NOTIFICATIONS_ALL,
		nil];
}
- (NSString *) applicationNameForGrowl {
	return @"Palourde";
}

- (NSArray *) contaminations {
    return [contaminations retain];
}


- (void)dealloc {
	[paMenu release];
	[paItem release];
	[paImageActive release];
	[paImageInactive release];
	[animSpraying release];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
	[folderDownloads release];
	[folderMailDownloads release];
	[super dealloc];
}
@end
