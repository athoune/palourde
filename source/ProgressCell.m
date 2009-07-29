//
//  ProgressCell.m
//  Palourde
//
//  Created by Mathieu on 24/07/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//
// Stolen from http://www.cocoadev.com/index.pl?NSViewInNSTableView

#import "ProgressCell.h"

@implementation ProgressCell

-(id)init {
    return self;
}

- (id)initProgressCell : (NSProgressIndicator *)aProgressIndicator {
    if( self = [ super initImageCell:nil ] ) {
        progressIndicator = [ aProgressIndicator retain ];
    }
    return self;
}

- copyWithZone : (NSZone *)zone {
    ProgressCell *cell = (ProgressCell *)[ super copyWithZone:zone ];
    cell->progressIndicator = [ progressIndicator retain ];
    return cell;
}

- (void)dealloc {
    [ progressIndicator release ];
    [ super dealloc ];
}

- (void)setProgressIndicator : (NSProgressIndicator *)aProgressIndicator {
    if( aProgressIndicator )
    {
        [ progressIndicator release ];
        progressIndicator = [ aProgressIndicator retain ];
    }
}

///////////////////////////////////////////////////////////////////////
//  If you need, you can add - (NSProgressIndicator*) progressIndicator;
///////////////////////////////////////////////////////////////////////
- (NSProgressIndicator*) progressIndicator {
    return progressIndicator;
}

- (void)drawInteriorWithFrame : (NSRect)cellFrame inView : (NSView *)controlView {
    if( [ progressIndicator superview ] == nil ) {
        [ controlView addSubview:progressIndicator ];
    }
    [ progressIndicator setFrame:cellFrame ];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ProgressCell: %f/%f>", [progressIndicator doubleValue], [progressIndicator maxValue]];
}

- (void)setObjectValue:(id < NSCopying >)object {
    progressIndicator = [object copy];
}

@end