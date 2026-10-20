VERSION="0.1.0"

class Pelicode < Formula
  desc "Know where your code came from."
  homepage "https://github.com/tamada/pelicode"
  version VERSION
  license "MIT License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/pelicode/releases/download/v0.1.0/pelicode-0.1.0_darwin_amd64.tar.gz"
    sha256 "44f468dad02434fe2f07d309be09db8329b5821f9608a110167fc4b3b364f7f2"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/pelicode/releases/download/v0.1.0/pelicode-0.1.0_darwin_arm64.tar.gz"
    sha256 "36381f5554f021a967094d4b3d43a7127b7767c49117154ffebc7f33537b32cf"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/pelicode/releases/download/v0.1.0/pelicode-0.1.0_linux_amd64.tar.gz"
    sha256 "93c0360da71b49693f6eea14070c9af1dafe7129ed01485bda2138305d168128"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/pelicode/releases/download/v0.1.0/pelicode-0.1.0_linux_arm64.tar.gz"
    sha256 "aea0779d201d6d851cd1a9ea4f1ff8526f679e913c9a43468a91c982f721730c"
  end

  def install
    bin.install "pelicode"
  end

  test do
    system "#{bin}/pelicode --version"
  end
end
