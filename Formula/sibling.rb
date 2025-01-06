VERSION="v2.0.0-beta-7"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-7/sibling-2.0.0-beta-7_darwin_amd64.tar.gz"
    sha256 "d2ab423a593479925b93da3b73e0e927e41350a1bf1cb1a28a5b4ef344c006bf"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-7/sibling-2.0.0-beta-7_darwin_arm64.tar.gz"
    sha256 "5983acfcc4f3cb1c998f2630e45c64a678be9e84ffba74c16d2993afdc687be7"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-7/sibling-2.0.0-beta-7_linux_amd64.tar.gz"
    sha256 "91ad1c21e8b3992958863e05ddabe18802eda4ebbcbb561819ad44acb262fac8"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-7/sibling-2.0.0-beta-7_linux_arm64.tar.gz"
    sha256 "6f55a1212530bf43ef188d352f69fd26b8640c0b970e613151cc48de056e597b"
  end


  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
