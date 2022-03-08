#include <SUU-Runtime/SUU-Runtime.hpp>
#include <SUU-Runtime/Remote/Hello.hpp>
#include <SUU-Runtime/Remote/RuntimeCapture.hpp>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <iostream>
#include <thread>

int main(int, const char*[])
{
    std::cout << suu::PlatformName() << std::endl;

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

    while (true)
    {
        offset += 2;
        send_image(offset);
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    // Display* display = XOpenDisplay(nullptr);

    // if (display == nullptr) {
    //     std::cout << "XOpenDisplay failed!!" << std::endl;
    //     exit(1);
    // }

    // int screen = DefaultScreen(display);

    // int black = BlackPixel(display, screen);
    // int white = WhitePixel(display, screen);

    // Window window = XCreateSimpleWindow(
    //     display,
    //     DefaultRootWindow(display),
    //     0,
    //     0,
    //     300,
    //     300,
    //     5,
    //     black,
    //     white);

    // XSetStandardProperties(display, window, "SUU-Runtime", "Hi", None, nullptr, 0, nullptr);
    // XSelectInput(display, window, ExposureMask | ButtonPressMask | KeyPressMask);
    // GC gc = XCreateGC(display, window, 0, nullptr);
    // XSetBackground(display, gc, white);
    // XSetForeground(display, gc, black);
    // XMapRaised(display, window);

    // XEvent xEvent;
    // char text[256];
    // while (true) {
    //     XNextEvent(display, &xEvent);
    //     if (xEvent.type == Expose && xEvent.xexpose.count == 0) {
    //         XClearWindow(display, window);
    //     }
    // }

    // XDestroyWindow(display, window);
    // XCloseDisplay(display);

    return 0;
}
