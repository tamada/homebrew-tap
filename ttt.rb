require "formula"

HOMEBREW_TTT_VERSION="1.0.0"

class Ttt < Formula
  desc "Verifying diploma of courses in ISE, KSU."
  homepage "https://github.com/tamada/ttt"
  url "https://github.com/tamada/ttt/releases/download/v1.0.0/ttt-#{HOMEBREW_TTT_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_TTT_VERSION
  sha256 "d43a4bcdc5d1838c093f6ae695f26d2aa78490e64bacc60df001db7f92400c4b"

  depends_on "go"  => :build

  def install
      bin.install "ttt"
      pkgshare.install "data"
  end
end
