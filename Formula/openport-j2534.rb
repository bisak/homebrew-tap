class OpenportJ2534 < Formula
  desc "SAE J2534 PassThru driver for the Tactrix OpenPort 2.0 (macOS, Linux)"
  homepage "https://github.com/bisak/openport-j2534"
  url "https://github.com/bisak/openport-j2534/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c727cb1abba7ce30bc504c4486524d92df13dd10b2d06374b98a401d90d2b557"
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
