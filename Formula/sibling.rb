VERSION="v3.0.0"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v3.0.0/sibling-3.0.0_darwin_amd64.tar.gz"
    sha256 "7aa9c728a44a823ffe5b86eefd5855d89b361c8d740bf87fc02ac0a62d677d5c"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v3.0.0/sibling-3.0.0_darwin_arm64.tar.gz"
    sha256 "d188396d8a3e7b05944c7b8b31a8eab5d715a45ca58b85e29a4b7449b9447973"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v3.0.0/sibling-3.0.0_linux_amd64.tar.gz"
    sha256 "f606e8541f071c5569bad1eee7f87103a580b61d4baa40759bf2e69cb2e5830a"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v3.0.0/sibling-3.0.0_linux_arm64.tar.gz"
    sha256 "beeb1812ff64449a3c97e4c5bb3a1334bf5e85e6957074f5e62619a26b60e775"
  end

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
