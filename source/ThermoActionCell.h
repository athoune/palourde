//
//  ThermoActionCell.h
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ThermoActionCell : ActionCell {
    double max;
    double doubleValue;
}
-(id) initWithName: (NSString *) theName andMax:(double) theMax andIcon:(NSImage*) theIcon;
-(void) setDoubleValue: (double) value;
@end
