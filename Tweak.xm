#import "AI.h"

@interface ViewController : UIViewController
-(void)makeMove:(NSInteger)move;
-(void)upSwipeHandle:(id)handle;
-(void)downSwipeHandle:(id)handle;
-(void)leftSwipeHandle:(id)handle;
-(void)rightSwipeHandle:(id)handle;
@end

NSInteger codeCount;
BOOL AIEnabled;
BOOL gameOver;

%hook ViewController
%new
-(void)initializeAI{
    AIEnabled = YES;
    [[%c(UIApplication) sharedApplication] setIdleTimerDisabled:YES];
    while(! gameOver){
	NSMutableArray* array = MSHookIvar<NSMutableArray*>(self, "theCubeTab");
	dispatch_sync(dispatch_get_main_queue(), ^{
	    [self makeMove:[AI bestMoveForArray:array]];
	});
    }
}
%new
-(void)makeMove:(NSInteger)move{
    switch (move){
    case 0:
	[self upSwipeHandle:nil];
	break;
    case 1:
	[self downSwipeHandle:nil];
	break;
    case 2:
	[self leftSwipeHandle:nil];
	break;
    case 3:
	[self rightSwipeHandle:nil];
	break;
    default:
	break;
  }
}

-(void)rightSwipeHandle:(id)handle{
    %orig;
    if(! AIEnabled){
	if(codeCount == 5 || codeCount == 7) codeCount++;
	else codeCount =0;

	if(codeCount == 8){
	    [NSThread detachNewThreadSelector:@selector(initializeAI) toTarget:self withObject:nil];
	}
    }
}
-(void)leftSwipeHandle:(id)handle{
    %orig;
    if(! AIEnabled){
	if(codeCount == 4 || codeCount==6) codeCount++;
	else codeCount = 0;
    }
}
-(void)downSwipeHandle:(id)handle{
    %orig;
    if(! AIEnabled){
	if(codeCount>1 && codeCount <4) codeCount++;
	else codeCount = 0;
    }
}
-(void)upSwipeHandle:(id)handle{
    %orig;
    if(! AIEnabled){
	if(codeCount < 2) codeCount++;
	else codeCount = 0;
    }
}

-(void)gameOver:(id)over{
    %orig;
    gameOver = YES;
}

-(void)tryAgain:(id)again{
    %orig;
    if(AIEnabled){
	[NSThread detachNewThreadSelector:@selector(initializeAI) toTarget:self withObject:nil];
    }
}
-(void)startGame{
    %orig;
    AIEnabled = NO;
    codeCount = 0;
    gameOver = NO;
}
%end

%ctor{
    %init;
}
