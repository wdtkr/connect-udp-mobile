#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaLibBridge : NSObject

typedef void (^DebugCallbackBlock)(NSString *message);
typedef void (^ReceiveCallbackBlock)(NSData *data, int length, int type);

+ (void)setMediaCallbackWithDebug:(DebugCallbackBlock)debug
                     receiveVideo:(ReceiveCallbackBlock)receiveVideo
                     receiveAudio:(ReceiveCallbackBlock)receiveAudio;


+ (void)setLibraryPath:(NSString *)path;

+ (void)setAddressAndPortWithAddress:(NSString *)address
                           myTcpPort:(int)myTcpPort
                         peerTcpPort:(int)peerTcpPort
                         myVideoPort:(int)myVideoPort
                       peerVideoPort:(int)peerVideoPort
                         myAudioPort:(int)myAudioPort
                       peerAudioPort:(int)peerAudioPort;

+ (BOOL)initializeTcpSender;
+ (BOOL)initializeTcpReceiver;
+ (void)closeTcpSocket;

+ (int)initEncodeVideoData:(int)videoFormat;
+ (void)encodeVideoData:(NSData *)inputData;
+ (void)initEncodeAudioData;
+ (void)encodeAudioData:(NSData *)audioData;

+ (void)initDecodeVideoData;
+ (void)receiveAndDecodeVideoData;
+ (void)initDecodeAudioData;
+ (void)receiveAndDecodeAudioData;

+ (void)destroyEncoder;
+ (void)destroyDecoder;

+ (void)test;

@end

NS_ASSUME_NONNULL_END
