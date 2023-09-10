#import <Foundation/Foundation.h>
#import "lib-bridge.h"
#import "lib.hpp"

@implementation LibCpp

-(void)triggerCallback {
    triggerCallback();
}

// グローバルにObjective-CのCallbackBlockを保存する
static CallbackBlock globalDebugBlock = nil;
static CallbackBlock globalReceiveBlock = nil;
static CallbackBlock globalStartBlock = nil;

// C関数として呼び出される関数
static void debugCFunction(const char *message) {
    if (globalDebugBlock != nil) {
        globalDebugBlock([NSString stringWithUTF8String:message]);
    }
}

static void receiveCFunction(const char *message) {
    if (globalReceiveBlock != nil) {
        globalReceiveBlock([NSString stringWithUTF8String:message]);
    }
}

static void startCFunction(const char *message) {
    if (globalStartBlock != nil) {
        globalStartBlock([NSString stringWithUTF8String:message]);
    }
}

// Objective-C++のメソッド内で設定
-(void)setCallback:(CallbackBlock)debug
                    receive:(CallbackBlock)receive
                      start:(CallbackBlock)start {
    
    // グローバルにObjective-CのCallbackBlockを保存
    globalDebugBlock = [debug copy];
    globalReceiveBlock = [receive copy];
    globalStartBlock = [start copy];
    
    // C++ 関数を呼ぶ
    setCallback(debugCFunction, receiveCFunction, startCFunction);
}

-(void)sendUDPMessage:(NSString *)IP port:(int)port message:(NSString *)message {
    const char *cIP = [IP UTF8String];
    const char *cMessage = [message UTF8String];
    sendUDPMessage(cIP, port, cMessage);
}

-(void)preReceiveUDPMessage:(int)port{
    preReceiveUDPMessage(port);
}

-(void)receiveUDPMessage{
    receiveUDPMessage();
}

-(void)socketClose{
    socketClose();
}

@end
