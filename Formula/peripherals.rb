VERSION="0.9.6"

class Peripherals < Formula
  desc "peripheral utility commands for the shell."
  homepage "https://github.com/tamada/peripherals"
  url "https://github.com/tamada/peripherals/releases/download/v#{VERSION}/peripherals-#{VERSION}-darwin-arm64.tar.gz"
  version VERSION
  sha256 "45562b63b42d5abf9d21e08d3e2b80c32e80d5c21d85a820bf23bf13352d49ff"
  license "MIT"

  def install
    bin.install "bin/ptest"
    bin.install "bin/puniq"
    bin.install "bin/ptake"
    bin.install "bin/pskip"
  end
end
