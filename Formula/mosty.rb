VERSION="0.1.0"

class Mosty < Formula
  desc "MOu Seiseki Teisei ha Yadayo!"

  homepage "https://github.com/tamada/mosty"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/mosty/releases/download/v0.1.0/mosty-0.1.0_amd64_darwin.tar.gz"
    sha256 "3ddf1b0f11fe4f5c8517b39e3eaf9a47cd209ee27c8f5fadc1e25b18f029cbcd"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/mosty/releases/download/v0.1.0/mosty-0.1.0_amd64_linux.tar.gz"
    sha256 "9a4af3ffc999390979925f1cb0d150ea22a16846ef3ebb0c9a5813680fbf7fef"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/mosty/releases/download/v0.1.0/mosty-0.1.0_arm64_darwin.tar.gz"
    sha256 "9106d013735828ca6c30863b0abd7144bad9b8258bbd33b12b2ad8b9e626e96e"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/mosty/releases/download/v0.1.0/mosty-0.1.0_arm64_linux.tar.gz"
    sha256 "e18d35ed6a71cbfb34f9cc01f2d1d079c230abb8b823b58e62cbe844af3ff8a3"
  end

  def install
    bin.install "mosty"
  end

  test do
    system "#{bin}/mosty --version"
  end
end
