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

-(id) initWithName: (NSString *) theName andMax:(double) theMax{
    progressIndicator = [[NSProgressIndicator alloc] init];
    [progressIndicator setMaxValue:theMax];
    cell = [[ProgressCell alloc] initProgressCell:progressIndicator];
    return self;
}

-(NSCell*) displayDetail {
    return [cell autorelease];
}

-(NSProgressIndicator*) thermometre {
    return progressIndicator;
}

@end
