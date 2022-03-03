#include <jni.h>
#include <string>
#include <SUU-Runtime/SUU-Runtime.hpp>
#include <SUU-Runtime/Remote/Hello.hpp>

extern "C" JNIEXPORT jstring JNICALL
Java_com_suu_1games_suu_1runtime_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    remote::SayHello("SUUDAI");
    suu::String hello = suu::PlatformName();
    return env->NewStringUTF(hello.c_str());
}