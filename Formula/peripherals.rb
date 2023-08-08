VERSION="v1.0.1"

class Peripherals < Formula
  desc "peripheral utility commands for the shell."
  homepage "https://github.com/tamada/peripherals"
  version VERSION
  license "MIT License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/peripherals/releases/download/v1.0.1/peripherals-1.0.1-darwin-amd64.tar.gz"
    sha256 "704d1a21cce976435ab90c2c41a6bd5ba0d1b7f003317ef220559477ffc917e1"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/peripherals/releases/download/v1.0.1/peripherals-1.0.1-darwin-arm64.tar.gz"
    sha256 "4e52e5c9bbd96f77afa71ecf48afa5bbfb12ebd39e89deedd831ee03f2741936"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/peripherals/releases/download/v1.0.1/peripherals-1.0.1-linux-amd64.tar.gz"
    sha256 "b85a492df73c08a75bebe924f19ee45cb199222b780ce617e160f7b685a93392"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/peripherals/releases/download/v1.0.1/peripherals-1.0.1-linux-arm64.tar.gz"
    sha256 "e765342cbf7c8b2e4b39f8b13262ba872e098af431d78c240922edb0bfa5c99d"
  end

  def install
    bin.install "bin/ptest"
    bin.install "bin/puniq"
    bin.install "bin/ptake"
    bin.install "bin/pskip"
    bin.install "bin/snip"
  end
end
