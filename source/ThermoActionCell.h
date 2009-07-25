//
//  ThermoActionCell.h
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressCell.h"

@interface ThermoActionCell : ActionCell {
    NSProgressIndicator *thermometre;
    ProgressCell *cell;
    NSProgressIndicator *progressIndicator;
}
-(NSProgressIndicator*) thermometre;
-(id) initWithName: (NSString *) theName andMax:(double) theMax;
@end
