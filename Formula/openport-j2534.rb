class OpenportJ2534 < Formula
  desc "SAE J2534 PassThru driver for the Tactrix OpenPort 2.0 (macOS, Linux)"
  homepage "https://github.com/bisak/openport-j2534"
  url "https://github.com/bisak/openport-j2534/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8c810836df20c88726413dc546a2672ed71cd80097166271d2784cff247c5991"
  license "GPL-3.0-or-later"
  head "https://github.com/bisak/openport-j2534.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <j2534/j2534.h>
      int main(void) {
        unsigned long d = 0;
        long rc = PassThruOpen(0, &d);
        if (rc == STATUS_NOERROR) return PassThruClose(d) == STATUS_NOERROR ? 0 : 1;
        return rc == ERR_DEVICE_NOT_CONNECTED ? 0 : 1;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs openport-j2534").split
    system ENV.cc, "t.c", *flags, "-o", "t"
    system "./t"
  end
end
