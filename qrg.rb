require "formula"

HOMEBREW_QRG_VERSION="1.0.0"

class Qrg < Formula
  desc "QR code generator"
  homepage "https://github.com/tamada/qrg"
  url "https://github.com/tamada/qrg.git", :tag => "v#{HOMEBREW_QRG_VERSION}"
  version HOMEBREW_QRG_VERSION
  head "https://github.com/tamada/qrg.git", :branch => "master"

  depends_on "go"  => :build

  def install
    ENV['GOPATH'] = buildpath
    ENV['GO111MODULE'] = 'on'
    uniq2_path = buildpath/"src/github.com/tamada/qrg/"
    uniq2_path.install buildpath.children

    cd uniq2_path do
      system "make", "build"
      bin.install "cmd/uniq2/qrg"
    end
  end
end
