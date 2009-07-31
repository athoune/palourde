//
//  ThermoActionCell.m
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionCell.h"
#import "ThermoActionCell.h"

@implementation ThermoActionCell

-(id) initWithName: (NSString *) theName andMax:(double) theMax andIcon:(NSImage *) theIcon {
    if(theName == nil)
	return nil;
    max = theMax;
    name = [theName copy];
    icon = [theIcon copy];
    return self;
}

-(NSNumber*) detail {
    //return [NSNumber numberWithInt:50];
    return [NSNumber numberWithDouble: 100 * doubleValue / max];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ThermoActionCell: %@ %f/%f>", name, doubleValue, max];
}

-(void) setDoubleValue:(double) theValue {
    NSLog(@"set value: %f", theValue);
    doubleValue = theValue;
}

@end
