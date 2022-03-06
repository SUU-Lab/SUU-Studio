using System.ComponentModel;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace SUU_Studio.ViewModel
{
    public class RuntimeCaptureImage
    {
        public BitmapSource? ImageSource { get; set; }
    }

    public class RuntimeCaptureImageViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler? PropertyChanged;

        public RuntimeCaptureImage RuntimeCaptureImage { get; set; }

        public BitmapSource? ImageSource
        {
            get
            {
                return RuntimeCaptureImage.ImageSource;
            }
            set
            {
                RuntimeCaptureImage.ImageSource = value;

                if (PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs("ImageSource"));
                }
            }
        }

        public RuntimeCaptureImageViewModel()
        {
            RuntimeCaptureImage = new RuntimeCaptureImage();
            ClearRuntimeImage();
        }

        public void ClearRuntimeImage()
        {
            const int width = 100;
            const int height = 100;
            byte[] imageBuffer = new byte[width * height * 4];

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    int i = 4 * (y * width + x);
                    imageBuffer[i] = 10;
                    imageBuffer[i + 1] = 20;
                    imageBuffer[i + 2] = 30;
                    imageBuffer[i + 3] = 255;
                }
            }

            UpdateImage(imageBuffer, width, height, width, height);
        }

        public void UpdateImage(
            byte[] imageBuffer,
            int bufferWidth, int bufferHeight,
            int width, int height)
        {

            int stride = bufferWidth * ((PixelFormats.Pbgra32.BitsPerPixel + 7) / 8);
            BitmapSource image = BitmapSource.Create(bufferWidth, bufferHeight, 96, 96, PixelFormats.Pbgra32, null, imageBuffer, stride);

            // クリッピング
            if (bufferWidth != width ||
                bufferHeight != height)
            {
                image = new CroppedBitmap(image, new Int32Rect(0, 0, width, height));
            }

            //// スケーリング
            //if (RuntimeImage.Width != width ||
            //    RuntimeImage.Height != height)
            //{
            //    double scaleWidth = RuntimeImage.Width / width;
            //    double scaleHeight = RuntimeImage.Height / height;
            //    ScaleTransform transform = new ScaleTransform(scaleWidth, scaleHeight);
            //    image = new TransformedBitmap(image, transform);
            //}

            ImageSource = image;
        }
    }
}
