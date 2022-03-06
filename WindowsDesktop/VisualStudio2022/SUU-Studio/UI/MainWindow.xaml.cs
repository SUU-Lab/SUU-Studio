using SUU_Studio.ViewModel;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Windows;

namespace SUU_Studio
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        //[DllImport("user32.dll")]
        //private static extern bool SetWindowText(IntPtr hWnd, string lpString);

        //[DllImport("user32.dll")]
        //static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        //private delegate bool EnumChildWindowsDelegate(IntPtr hWnd, IntPtr lParam);

        //[DllImport("user32.dll")]
        //private static extern bool EnumChildWindows(IntPtr hWnd, EnumChildWindowsDelegate lpEnumFunc, IntPtr lParam);


        //[StructLayout(LayoutKind.Sequential)]
        //public struct RECT
        //{
        //    public int Left;
        //    public int Top;
        //    public int Right;
        //    public int Bottom;
        //}

        //[DllImport("user32.dll")]
        //private static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int y, int cx, int cy, int uFlags);


        //private const int SWP_NOZORDER = 0x0004;
        //private const int SWP_NOMOVE = 0x0002;

        //private bool EnumChildWindowsProcedure(IntPtr hWnd, IntPtr lParam)
        //{
        //    GetWindowRect(RuntimeWindow.Handle, out RECT rc);
        //    SetWindowPos(hWnd, IntPtr.Zero,
        //        0,
        //        0,
        //        rc.Right - rc.Left,
        //        rc.Bottom - rc.Top,
        //        SWP_NOZORDER | SWP_NOMOVE);
        //    return true;
        //}

        //private void WindowsFormsHost_Loaded(object sender, RoutedEventArgs e)
        //{
        //    SetWindowText(RuntimeWindow.Handle, "SUU Studio Runtime");
        //}

        //private void RuntimeWindow_SizeChanged(object sender, EventArgs e)
        //{
        //    EnumChildWindows(RuntimeWindow.Handle, EnumChildWindowsProcedure, RuntimeWindow.Handle);
        //}

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            Remote.HelloServer.Shutdown();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            Remote.HelloServer.Start((RuntimeCaptureImageViewModel)RuntimeCaptureImage.DataContext, Dispatcher);
        }
    }

}
