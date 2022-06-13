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
    qrg_path = buildpath/"src/github.com/tamada/qrg/"
    qrg_path.install buildpath.children

    cd qrg_path do
      system "make", "build"
      bin.install "qrg"
    end
  end
end
