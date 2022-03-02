#include <SUU-Runtime/SUU-Runtime.hpp>
#include <SUU-Runtime/Remote/Hello.hpp>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <iostream>

int main(int, const char*[])
{
    // std::cout << suu::PlatformName() << std::endl;

    remote::SayHello("SUUDAI");

    Display* display = XOpenDisplay(nullptr);

    if (display == nullptr) {
        std::cout << "XOpenDisplay failed!!" << std::endl;
        exit(1);
    }

    int screen = DefaultScreen(display);

    int black = BlackPixel(display, screen);
    int white = WhitePixel(display, screen);

    Window window = XCreateSimpleWindow(
        display,
        DefaultRootWindow(display),
        0,
        0,
        300,
        300,
        5,
        black,
        white);

    XSetStandardProperties(display, window, "SUU-Runtime", "Hi", None, nullptr, 0, nullptr);
    XSelectInput(display, window, ExposureMask | ButtonPressMask | KeyPressMask);
    GC gc = XCreateGC(display, window, 0, nullptr);
    XSetBackground(display, gc, white);
    XSetForeground(display, gc, black);
    XMapRaised(display, window);

    XEvent xEvent;
    char text[256];
    while (true) {
        XNextEvent(display, &xEvent);
        if (xEvent.type == Expose && xEvent.xexpose.count == 0) {
            XClearWindow(display, window);
        }
    }

    XDestroyWindow(display, window);
    XCloseDisplay(display);

    return 0;
}
