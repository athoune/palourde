//
//  Client.m
//  iClam
//
//  Created by Mathieu Lecarme on 05/01/09.
//  Copyright 2009 Noven. All rights reserved.
//

#import "ClamavClient.h"
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

NSString * const PAOneVirus = @"PAOneVirusToken";
NSString * const PAScanFinished = @"PAScanDone";

/*
 http://www.ecst.csuchico.edu/~beej/guide/ipc/usock.html
 http://lists.apple.com/archives/Cocoa-dev/2005/Aug/msg01966.html
 */

@implementation ClamavClient
- (id) init {
    [self dealloc];
    @throw [NSException exceptionWithName:@"BadInitCode" reason:@"Il faut l'initialiser avec un chemin" userInfo:nil];
    return nil;
}

-(id) initWithPath: (NSString *)thePath {
    if(![super init])
		return nil;
    if(thePath == nil)
		return nil;
    path = [thePath copy];
    return self;
}

+ (NSOperationQueue*) sharedOperationQueue {
    static NSOperationQueue *operationQueue = nil;
    if(operationQueue == nil)
	operationQueue = [NSOperationQueue new];
    return operationQueue;
}

-(int) connect {
    int len;
    int sock = -1;
    struct sockaddr_un remote;
    
    memset((char *) &remote, 0, sizeof(remote));
    
    remote.sun_family = AF_UNIX;
    strncpy(remote.sun_path, [path cStringUsingEncoding:NSUTF8StringEncoding], sizeof(remote.sun_path));
    remote.sun_path[sizeof(remote.sun_path)-1]='\0';
    
    if ((sock = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
		perror("socket");
		exit(1);
    }
    
    len = strlen(remote.sun_path) + sizeof(remote.sun_family);
    if (connect(sock, (struct sockaddr *)&remote, sizeof(struct sockaddr_un)) == -1) {
		NSLog(@"Connection problem with %@", path);
		perror("connect");
		exit(1);
    }
    return sock;
}

-(NSString *) talk:(NSString *) command {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    int sock = [self connect];
    if (write(sock, [command cStringUsingEncoding:NSUTF8StringEncoding], [command lengthOfBytesUsingEncoding:NSUTF8StringEncoding]) == -1) {
	close(sock);
	perror("send");
	exit(1);
    }
    char buff[64];
    int bread;
    NSMutableString *rep = [NSMutableString stringWithCapacity:64];
    while((bread = read(sock, buff, sizeof(buff)-1)) > 0) {
	buff[bread] = '\0';
	[rep appendFormat:@"%s", buff]; 
	//printf("%s\n", buff);
    }
    [nc postNotificationName:PAScanFinished object:self];
    NSLog(@"%@", rep);
    close(sock);
    return rep;
}

-(BOOL *) ping {
    return [[self talk:@"PING"] isEqualToString:@"PONG"];
}

-(NSString *) version {
    return [self talk:@"VERSION"];
}

-(void) contscan:(NSString *) thePath {
	[thePath retain];
    NSDate *debut = [NSDate date];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    int cpt = 0;
    int sock = [self connect];
	NSString *cmd = [[NSString alloc] initWithFormat:@"CONTSCAN %@/", thePath];
    if (write(sock, [cmd cStringUsingEncoding:NSUTF8StringEncoding], 9 + [thePath lengthOfBytesUsingEncoding:NSUTF8StringEncoding]) == -1) {
		close(sock);
		perror("send");
		exit(1);
    }
	//[cmd release];
	cmd = nil;
    NSLog(@"scan started");
    char buff[2048];
    int bread;
    while((bread = read(sock, buff, sizeof(buff)-1)) > 0) {
		buff[bread] = '\0';
		//printf("%s", buff);
		NSString *line = [NSString stringWithFormat:@"%s", buff];
		NSString *file = [[line componentsSeparatedByString:@": "] objectAtIndex:0];
		NSString *virus = nil;
		if([[line substringFromIndex:[line length] - 7 ] isEqualToString:@" FOUND\n"]) {
			cpt ++;
			virus = [line substringWithRange:NSMakeRange([file length] + 2, [line length] - [file length] -9)];
			NSLog(@"virus : %@", virus);
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
			[userInfo setObject:virus forKey:@"virus"];
			virus = nil;
			[userInfo setObject:file forKey:@"file"];
			file = nil;
			[nc postNotificationName:PAOneVirus object:self userInfo: userInfo];
		}
	line = nil;
    }
    close(sock);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:[NSNumber numberWithFloat:[debut timeIntervalSinceNow] ] forKey:@"duration"];
    [userInfo setObject:[NSNumber numberWithInteger:cpt] forKey:@"count"];
    [nc postNotificationName:PAScanFinished 
			object:self 
		    userInfo:userInfo];
    NSLog(@"scan ended");
}

-(void) asyncScan:(NSString *) thePath {
    //NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
    //[thePath retain];
    [NSThread detachNewThreadSelector:@selector(contscan:)
							 toTarget:self
							withObject:thePath];
    /*NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
									selector:@selector(contscan:)
									object:thePath];
    [theOp autorelease];
    // Add the operation to the internal operation queue managed by the application delegate.
    [[Client sharedOperationQueue] addOperation:theOp];*/
    //[pool drain];
    //pool = nil;
}

- (void)dealloc {
	path = nil;
	[super dealloc];
}
@end
