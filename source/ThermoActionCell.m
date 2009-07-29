//
//  ThermoActionCell.m
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionCell.h"
#import "ThermoActionCell.h"
#import "ProgressCell.h"

@implementation ThermoActionCell

-(id) initWithName: (NSString *) theName andMax:(double) theMax andIcon:(NSImage *) theIcon {
    if(theName == nil)
	return nil;
    name = [theName copy];
    progressIndicator = [[[NSProgressIndicator alloc] init] autorelease];
    [progressIndicator setMaxValue: theMax];
    [progressIndicator setIndeterminate: FALSE];
    cell = [[[ProgressCell alloc] initProgressCell: progressIndicator] autorelease];
    icon = [theIcon copy];
    return self;
}

-(NSCell*) displayDetail {
    //return [NSString stringWithFormat:@"%f", 100 * [progressIndicator doubleValue] / [progressIndicator maxValue]];
    return cell;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ThermoActionCell: %@ %f/%f>", name, [progressIndicator doubleValue], [progressIndicator maxValue]];
}

-(NSProgressIndicator*) thermometre {
    return [progressIndicator retain];
}

-(void) setDoubleValue:(double) theValue {
    NSLog(@"set value: %f", theValue);
    [progressIndicator setDoubleValue:theValue];
}

@end
