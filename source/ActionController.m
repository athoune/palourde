//
//  ActionPanel.m
//  Palourde
//
// Controller for the actionpanel
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionController.h"
#import "ActionCell.h"
#import "Contamination.h"
#import "ThermoActionCell.h"

@implementation ActionController
-(id)init {
    [self dealloc];
    @throw [NSException exceptionWithName:@"BadInitCode" reason:@"Init with the main controller" userInfo:nil];
    return nil;
}

-(id)initWithMainController:(PAController *)_mainController {
    if (![super initWithWindowNibName:@"ActionPanel"])
	return nil;
    mainController = _mainController;
    return self;
}

- (void)windowDidLoad {
	NSLog(@"Nib chargé");
}

-(void) awakeFromNib {
	NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[distributedCenter addObserver:self
		selector:@selector(freshclamDownload:)
		name:@"net.clamav.freshclam.download"
		object:nil];
	[center addObserver:self
		selector:@selector(contaminationAdded:)
		name:PAVirusAdded
		     object:nil];
    infos = [[NSMutableDictionary alloc] initWithCapacity:3];
    //[[actionTable tableColumnWithIdentifier:@"Icon"] setDataCell:[[[NSImageCell alloc] initImageCell:nil] autorelease]];
    //[[actionTable tableColumnWithIdentifier:@"Details"] setDataCell:[[[ProgressCell alloc] init] autorelease]];
}

-(void) reset {
}

-(void)add:(ActionCell *)action {
    [infos setObject:action forKey:[action name]];
}
-(void)remove:(ActionCell *)action {
    [infos removeObjectForKey:[action name]];
}

-(void) contaminationAdded: (NSNotification *)notification {
}

- (void) freshclamDownload: (NSNotification *)notification {
    NSLog(@"Thermo FreshClam Download %@", [notification userInfo] );
    NSString *filename = [[notification userInfo] objectForKey:@"file"];
    if([infos objectForKey:filename] == nil) {
	NSLog(@"New download file : %@ with size : %@", filename, [[notification userInfo] objectForKey:@"total" ]);
	[self add:
	 [[
	   [ThermoActionCell alloc]
		initWithName: filename 
		andMax: [[[notification userInfo] objectForKey:@"total" ] doubleValue]
		andIcon: [[NSWorkspace sharedWorkspace] iconForFileType:@"cvd"]
	   ] autorelease]
	];
	NSLog(@"icon : %@", [[NSWorkspace sharedWorkspace] iconForFileType:@"cvd"]);
    }
    NSLog(@"downloaded : %@ = %f", [[notification userInfo] objectForKey:@"downloaded"], [[[notification userInfo] objectForKey:@"downloaded"] doubleValue]);
    [[infos objectForKey:filename] setDoubleValue:[[[notification userInfo] objectForKey:@"downloaded"] doubleValue]];
    [actionTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [infos count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row{
    //NSLog(@"beuha : %@:%@", aTableColumn, rowIndex);
    NSParameterAssert(row >= 0 && row < [infos count]);
    ActionCell *action = [infos objectForKey:[[infos allKeys] objectAtIndex:row]];
    id data = nil;
    if(aTableColumn == nil || [[aTableColumn identifier] isEqualToString: @"Title"]) {
	data = [action name];
    }
    if([[aTableColumn identifier] isEqualToString: @"Details"]) {
	NSLog(@"thermo value: %f", [action detail]);
	data = [action detail];
    }
    if([[aTableColumn identifier] isEqualToString: @"Icon"]) {
	data = [action icon];
    }
    NSLog(@"Data: %@", data);
    return data;
}

/*
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if(tableColumn == nil) {
	return nil;
    }
    if([[tableColumn identifier] isEqualToString: @"Icon"]){
	return [[NSCell alloc] initImageCell:nil];
    }
    return [[NSCell alloc] init];*/
    /*
    NSLog(@"deja cell:", [tableColumn dataCell]);
    ActionCell *action = [infos objectForKey:[[infos allKeys] objectAtIndex:row]];
    NSLog(@"index: %i, key: %@ => %@", row, [[infos allKeys] objectAtIndex:row], action);
    NSLog(@"column: %@", tableColumn);
    if(tableColumn == nil || [[tableColumn identifier] isEqualToString: @"Title"]) {
	return [action displayTitle];
    }
    if([[tableColumn identifier] isEqualToString: @"Details"]) {
	NSLog(@"details: %@", [action displayDetail]);
	return nil;//[action displayDetail];
    }
    if([[tableColumn identifier] isEqualToString: @"Icon"]) {
	NSLog(@"icon: %@", [action displayIcon]);
	return [action displayIcon];
    }
    return nil;
     */
//}

@end