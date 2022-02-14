#include <jni.h>
#include <string>
#include <SUU-Runtime/SUU-Runtime.hpp>

extern "C" JNIEXPORT jstring JNICALL
Java_com_suu_1games_suu_1runtime_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    suu::String hello = suu::PlatformName();
    return env->NewStringUTF(hello.c_str());
}