//
//  Client.h
//  iClam
//
//  Created by Mathieu Lecarme on 05/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const PAOneVirus;
extern NSString * const PAScanFinished;

@interface ClamavClient : NSObject {
	NSString *path;
}

-(id) initWithPath: (NSString *)thePath;
-(BOOL) ping;
//Clamd version
-(NSString *) version;
-(void) contscan:(NSString *) thePath;
-(void) asyncScan:(NSString *) thePath;
+(NSOperationQueue*) sharedOperationQueue;
@end
