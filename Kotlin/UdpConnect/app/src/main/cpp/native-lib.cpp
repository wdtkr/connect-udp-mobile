#include <jni.h>
#include "lib.hpp"

static JavaVM *gJvm = nullptr;
static jobject gMainActivityInstance = nullptr;
static jmethodID gDebugCallbackMethodId = nullptr;
static jmethodID gReceiveCallbackMethodId = nullptr;
static jmethodID gStartCallbackMethodId = nullptr;

// JNIからJavaのメソッドを呼び出すためのヘルパー関数
void CallJavaMethod(JNIEnv *env, jobject instance, jmethodID methodId, const char *message) {
    jstring jMessage = env->NewStringUTF(message);
    env->CallVoidMethod(instance, methodId, jMessage);
    env->DeleteLocalRef(jMessage);
}

void DebugCallback(const char *message) {
    JNIEnv *env;
    gJvm->AttachCurrentThread(&env, nullptr);
    CallJavaMethod(env, gMainActivityInstance, gDebugCallbackMethodId, message);
//    gJvm->DetachCurrentThread();
}

void ReceiveCallback(const char *message, ssize_t length, int flags) {
    JNIEnv *env;
    gJvm->AttachCurrentThread(&env, nullptr);
    CallJavaMethod(env, gMainActivityInstance, gReceiveCallbackMethodId, message);
//    gJvm->DetachCurrentThread();
}

void StartCallback(const char *message) {
    JNIEnv *env;
    gJvm->AttachCurrentThread(&env, nullptr);
    CallJavaMethod(env, gMainActivityInstance, gStartCallbackMethodId, message);
//    gJvm->DetachCurrentThread();
}

extern "C" JNIEXPORT void JNICALL
Java_com_example_udpconnect_MainActivity_setCallback(JNIEnv *env, jobject thiz,
                                                     jobject debugCallback, jobject receiveCallback, jobject startCallback) {
    if (gJvm == nullptr) {
        env->GetJavaVM(&gJvm);
    }
    if (gMainActivityInstance != nullptr) {
        env->DeleteGlobalRef(gMainActivityInstance);
    }
    gMainActivityInstance = env->NewGlobalRef(thiz);

    jclass clazz = env->GetObjectClass(thiz);
    gDebugCallbackMethodId = env->GetMethodID(clazz, "debugCallback", "(Ljava/lang/String;)V");
    gReceiveCallbackMethodId = env->GetMethodID(clazz, "receiveCallback", "(Ljava/lang/String;II)V");
    gStartCallbackMethodId = env->GetMethodID(clazz, "startCallback", "(Ljava/lang/String;)V");

    if (gDebugCallbackMethodId == nullptr || gReceiveCallbackMethodId == nullptr || gStartCallbackMethodId == nullptr){
        return;
    }
    setCallback(DebugCallback, ReceiveCallback, StartCallback);
}

extern "C" JNIEXPORT void JNICALL
Java_com_example_udpconnect_MainActivity_sendUDPMessage(JNIEnv *env, jobject thiz,
                                                        jstring ip, jint port, jstring message) {
    const char *nativeIP = env->GetStringUTFChars(ip, nullptr);
    const char *nativeMessage = env->GetStringUTFChars(message, nullptr);

    // lib-udp-android.aの機能を使用してUDPメッセージを送信
    sendUDPMessage(nativeIP, port, nativeMessage);

    env->ReleaseStringUTFChars(ip, nativeIP);
    env->ReleaseStringUTFChars(message, nativeMessage);
}

extern "C" JNIEXPORT void JNICALL
    Java_com_example_udpconnect_MainActivity_preReceiveUDPMessage(JNIEnv *env, jobject thiz, jint port)
    {
        // lib-udp-android.aの機能を使用してUDPメッセージ受信の準備
        preReceiveUDPMessage(port);
    }

extern "C" JNIEXPORT void JNICALL
    Java_com_example_udpconnect_MainActivity_receiveUDPMessage(JNIEnv *env, jobject thiz)
    {
        // lib-udp-android.aの機能を使用してUDPメッセージを受信
        receiveUDPMessage();
    }

extern "C" JNIEXPORT void JNICALL
    Java_com_example_udpconnect_MainActivity_socketClose(JNIEnv *env, jobject thiz)
    {
        // lib-udp-android.aの機能を使用してソケットを閉じる
        socketClose();
    }
