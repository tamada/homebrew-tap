require "formula"

HOMEBREW_UNIQ2_VERSION="1.0.2"

class Uniq2 < Formula
  desc "Eliminating duplicated lines"
  homepage "https://github.com/tamada/uniq2"
  url "https://github.com/tamada/uniq2/releases/download/v#{HOMEBREW_UNIQ2_VERSION}/uniq2-v#{HOMEBREW_UNIQ2_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_UNIQ2_VERSION
  sha256 "99c64c4f68b4219d4cb36ff1e63bcd84ad2a94aee921f2852a4cb2130d597ee7"

  def install
    bin.install "uniq2"
  end
end
