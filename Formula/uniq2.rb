HOMEBREW_UNIQ2_VERSION="1.1.1"

class Uniq2 < Formula
  desc "Eliminating duplicated lines"
  homepage "https://github.com/tamada/uniq2"
  url "https://github.com/tamada/uniq2/releases/download/v#{HOMEBREW_UNIQ2_VERSION}/uniq2-#{HOMEBREW_UNIQ2_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_UNIQ2_VERSION
  sha256 "98facbeb8e134609eccead48031e5e411e1e723b9f8b9f48b9758ce3809c0eff"

  def install
    bin.install "uniq2"
  end
end
