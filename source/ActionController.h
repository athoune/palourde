//
//  ActionPanel.h
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HMBlkAppKit/HMBlkAppKit.h>

@interface ActionController : NSWindowController {
    IBOutlet HMBlkPanel *actionPanel;
    IBOutlet HMBlkTableView *actionTable;
}

@end
