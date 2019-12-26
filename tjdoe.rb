require "formula"

HOMEBREW_TJDOE_VERSION="1.0.0"

class Tjdoe < Formula
  desc "anonymizing the programs of the assignments in the programming courses and their score for grades."
  homepage "https://github.com/tamada/djdoe"
  url "https://github.com/tamada/tjdoe/releases/download/v1.0.0/tjdoe-#{HOMEBREW_TJDOE_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_TJDOE_VERSION
  sha256 "563c8d4349f1b1503c85b0c8489671f3e6639064449625401bb53124dcf02a9b"

  depends_on "go"  => :build

  def install
      bin.install "tjdoe"
  end
end
