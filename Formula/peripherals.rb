VERSION="1.0.1"
PRODUCT="peripherals"

class Peripherals < Formula
  desc "peripheral utility commands for the shell."
  homepage "https://github.com/tamada/peripherals"
  version VERSION
  license "MIT"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}-darwin_amd64.tar.gz"
    sha256 "1cba7f6b3c71230aa4c28b2cf1e11828633a294c1456d932868e1472e7ec90ed"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}-darwin_arm64.tar.gz"
    sha256 "f36f7f2f2280107bee3e740c9794cc048d5849d0303efd2c8bed99c96d9079d3"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}-linux_amd64.tar.gz"
    sha256 "e72e9b9a1e5c6030b718d5ed46f70d130f3b2944160871ae12096d6347e63855"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/#{PRODUCT}/releases/download/v#{VERSION}/#{PRODUCT}-#{VERSION}-linux_arm64.tar.gz"
    sha256 "089f19332301fbafaed6c88bd8616e27f3244b6c7ad4c71a6071013f775ed3f6"
  end

  def install
    bin.install "bin/ptest"
    bin.install "bin/puniq"
    bin.install "bin/ptake"
    bin.install "bin/pskip"
    bin.install "bin/snip"
  end
end
