#include <jni.h>
#include <string>
#include <SUU-Runtime/SUU-Runtime.hpp>
#include <SUU-Runtime/Remote/Hello.hpp>
#include <SUU-Runtime/Remote/RuntimeCapture.hpp>

extern "C" JNIEXPORT jstring JNICALL
Java_com_suu_1games_suu_1runtime_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {

    remote::SayHello("SUUDAI");

    remote::RuntimeCapture runtimeCapture;

    int width = 400, height = 400;

    std::uint8_t* buffer = new std::uint8_t[width * height * 4];

    auto send_image = [&](int offset) {
        int index = 0;
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {

                index = 4 * (y * width + x);
                buffer[index + 0] = 128;
                buffer[index + 1] = (((x + offset) / 100) % 2) ? 255 : 128;
                buffer[index + 2] = 128;
                buffer[index + 3] = 255;
            }
        }

        runtimeCapture.SendImage(
            buffer,
            width, height,
            width, height
        );
    };

    int offset = 0;
    send_image(offset);

    suu::String hello = suu::PlatformName();
    return env->NewStringUTF(hello.c_str());
}