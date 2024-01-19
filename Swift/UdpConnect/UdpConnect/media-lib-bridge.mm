#import "media-lib-bridge.h"
#include "media-lib.h"

@implementation MediaLibBridge

// グローバルにObjective-CのCallbackBlockを保存する
static DebugCallbackBlock globalDebugBlock = nil;
static ReceiveCallbackBlock globalReceiveVideoBlock = nil;
static ReceiveCallbackBlock globalReceiveAudioBlock = nil;

// Cレベルのコールバック関数
void DebugCallbackCFunction(const char *message) {
    if (globalDebugBlock) {
        NSString *msg = [NSString stringWithUTF8String:message];
        globalDebugBlock(msg);
    }
}

void ReceiveVideoCallbackCFunction(unsigned char *data, int length, int type) {
    if (globalReceiveVideoBlock) {
        NSData *dataObject = [NSData dataWithBytes:data length:length];
        globalReceiveVideoBlock(dataObject, length, type);
    }
}

void ReceiveAudioCallbackCFunction(unsigned char *data, int length, int type) {
    if (globalReceiveAudioBlock) {
        NSData *dataObject = [NSData dataWithBytes:data length:length];
        globalReceiveAudioBlock(dataObject, length, type);
    }
}


+ (void)setMediaCallbackWithDebug:(DebugCallbackBlock)debug
                     receiveVideo:(ReceiveCallbackBlock)receiveVideo
                     receiveAudio:(ReceiveCallbackBlock)receiveAudio {
    globalDebugBlock = [debug copy];
    globalReceiveVideoBlock = [receiveVideo copy];
    globalReceiveAudioBlock = [receiveAudio copy];
    
    // C関数ポインタをセット
    setMediaCallback(DebugCallbackCFunction, ReceiveVideoCallbackCFunction, ReceiveAudioCallbackCFunction);
}


+ (void)setLibraryPath:(NSString *)path {
    setLibraryPath([path UTF8String]);
}

+ (void)setAddressAndPortWithAddress:(NSString *)address
                           myTcpPort:(int)myTcpPort
                         peerTcpPort:(int)peerTcpPort
                         myVideoPort:(int)myVideoPort
                       peerVideoPort:(int)peerVideoPort
                         myAudioPort:(int)myAudioPort
                       peerAudioPort:(int)peerAudioPort {
    setAddressAndPort([address UTF8String], myTcpPort, peerTcpPort, myVideoPort, peerVideoPort, myAudioPort, peerAudioPort);
}

+ (BOOL)initializeTcpSender {
    return initializeTcpSender();
}

+ (BOOL)initializeTcpReceiver {
    return initializeTcpReceiver();
}

+ (void)closeTcpSocket {
    closeTcpSocket();
}

+ (int)initEncodeVideoData:(int)videoFormat {
    return initEncodeVideoData(videoFormat);
}

+ (void)encodeVideoData:(NSData *)inputData {
    encodeVideoData((unsigned char *)[inputData bytes], (int)[inputData length]);
}

+ (void)initEncodeAudioData {
    initEncodeAudioData();
}

+ (void)encodeAudioData:(NSData *)audioData {
    encodeAudioData((const unsigned char *)[audioData bytes], (int)[audioData length]);
}

+ (void)initDecodeVideoData {
    initDecodeVideoData();
}

+ (void)receiveAndDecodeVideoData {
    receiveAndDecodeVideoData();
}

+ (void)initDecodeAudioData {
    initDecodeAudioData();
}

+ (void)receiveAndDecodeAudioData {
    receiveAndDecodeAudioData();
}

+ (void)destroyEncoder {
    destroyEncoder();
}

+ (void)destroyDecoder {
    destroyDecoder();
}

+ (void)test {
    test();
}

@end

