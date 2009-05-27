//
//  Contamination.m
//  Palourde
//
//  Created by Mathieu on 26/05/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "Contamination.h"


@implementation Contamination
-(id) initWithPath:(NSString *)_path andVirus:(NSString *)_virus {
    path = _path;
    virus = _virus;
    return self;
}
-(NSString *) virus {
    return virus;
}

-(NSImage *) icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:path];
}

- (void)dealloc {
    [path release];
    path = nil;
    [virus release];
    virus = nil;
    [super dealloc];
}
@end
