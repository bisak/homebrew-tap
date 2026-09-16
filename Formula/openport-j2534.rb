class OpenportJ2534 < Formula
  desc "SAE J2534 PassThru driver for the Tactrix OpenPort 2.0 (macOS, Linux)"
  homepage "https://github.com/bisak/openport-j2534"
  url "https://github.com/bisak/openport-j2534/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "7b1df10b1f6d37e6a68e6049f1db0af2e11d945d9c562cb78c84b3a7631ac666"
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
      int main(void) { unsigned long d; return PassThruOpen(0, &d) == 0 ? 1 : 0; }
    EOS
    flags = shell_output("pkg-config --cflags --libs openport-j2534").split
    system ENV.cc, "t.c", *flags, "-o", "t"
    system "./t"
  end
end
