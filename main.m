//
//  main.m
//  BetaBuilder
//
//  Created by Hunter Hillegas on 8/7/10.
//  Copyright 2010 Hunter Hillegas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <unistd.h>
#import <stdio.h>
#import "BuilderController.h"

static int usage(char *name) {
	fprintf(stderr, "Usage: %s [options]\n", name);
	fprintf(stderr, "If no options are specified, the app runs in interactive mode.\n\
\n\
 -h            This message\n\
 -i <file>     The input file (.zip or .ipa) (required)\n\
 -o <dir>      The output directory (required)\n\
 -u <url>      The URL of the output directory (required)\n\
 -r <file>     The README.txt file to include (optional)\n\
\n");
	return(1);
}

int main(int argc, char *argv[])
{
	int ch;
	BOOL optBatch = NO;
	NSString *optInputFile = nil;
	NSString *optOutputDirectory = nil;
	NSString *optReadmePath = nil;
	NSString *optUrl = nil;
	
	// Do we have options?
	while((ch = getopt(argc, argv, "hi:o:r:u:")) != -1) {
		switch(ch) {
			case 'i':
				optBatch = YES;
				if(optInputFile != nil) [optInputFile release];
				optInputFile = [NSString stringWithCString:optarg encoding:NSASCIIStringEncoding];
				break;
				
			case 'o':
				optBatch = YES;
				if(optOutputDirectory != nil) [optOutputDirectory release];
				optOutputDirectory = [NSString stringWithCString:optarg encoding:NSASCIIStringEncoding];
				break;
				
			case 'r':
				optBatch = YES;
				if(optReadmePath != nil) [optReadmePath release];
				optReadmePath = [NSString stringWithCString:optarg encoding:NSASCIIStringEncoding];
				break;

			case 'u':
				optBatch = YES;
				if(optUrl != nil) [optUrl release];
				optUrl = [NSString stringWithCString:optarg encoding:NSASCIIStringEncoding];
				break;
				
			case 'h':
			case '?':
			default:
				return usage(argv[0]);
				break;
				
		}
	}

	if(!optBatch) {
		// Interactive gui loop
		return NSApplicationMain(argc,  (const char **) argv);
	}

	if(optInputFile == nil || optOutputDirectory == nil || optUrl == nil) {
		return usage(argv[0]);
	}
	
	BuilderController *bc = [[BuilderController alloc] initInBatchMode];

	// Drive the controller...
	bc.saveDirectory = optOutputDirectory;
	bc.readmePath = optReadmePath;
	bc.webserverDirectoryField.stringValue = optUrl;

	if(![bc setupFromIPAFile:optInputFile]) {
		exit(1);
	}
	[bc generateFiles:nil];
}
