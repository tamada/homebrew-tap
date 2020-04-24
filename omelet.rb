require "formula"

HOMEBREW_OMELET_VERSION="1.0.0"

class Omelet < Formula
  desc "An agent for running unit tests on the CLI environemnt for the Java platform."
  homepage "https://github.com/tamada/omelet"
  url "https://github.com/tamada/omelet/releases/download/v#{HOMEBREW_OMELET_VERSION}/omelet-#{HOMEBREW_OMELET_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_OMELET_VERSION
  sha256 ""

  depends_on "go"  => :build

  def install
      bin.install "tjdoe"
  end
end
