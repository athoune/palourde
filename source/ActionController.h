//
//  ActionPanel.h
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>
#import "PAController.h"
#import "PAAction.h"

#define NOTHING 1
#define GROWING 2
#define FULL 3
@interface ActionController : NSWindowController {
    IBOutlet BWTransparentTableView *actionTable;
    NSMutableDictionary *infos;
    PAController *mainController;
}

-(id)initWithMainController:(PAController *)mainController;
-(void)add:(PAAction *)action;
-(void)remove:(PAAction *)action;

//NSTableDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

//- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
@end
