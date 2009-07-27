//
//  ProgressCell.h
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#import <AppKit/Appkit.h>

@interface ProgressCell : NSCell
{
    NSProgressIndicator *progressIndicator;
}

- (id)initProgressCell : (NSProgressIndicator *)aProgressIndicator;
- (NSProgressIndicator*) progressIndicator;
@end