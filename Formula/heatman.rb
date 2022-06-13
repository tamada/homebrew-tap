HOMEBREW_HEATMAN_VERSION="1.0.1"

class Heatman < Formula
  desc "Creating heat map from given csv file."
  homepage "https://github.com/tamada/goheatman"
  url "https://github.com/tamada/goheatman/releases/download/v#{HOMEBREW_HEATMAN_VERSION}/heatman-#{HOMEBREW_HEATMAN_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_HEATMAN_VERSION
  sha256 "0bb68f9a24e624b2bf57a2442dc3637ebec5d51aa80a98f3bc09b520d2508b7a"

  def install
    bin.install "heatman"
  end
end
