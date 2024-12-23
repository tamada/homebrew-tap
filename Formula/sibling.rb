VERSION="v2.0.0-beta-6"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  version VERSION
  license "WTFPL License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-6/sibling-2.0.0-beta-6_darwin_amd64.tar.gz"
    sha256 "cb45de13b5d469de7a45aa524cb9e8da90207e43b29d8b221d20b01cbc869292"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-6/sibling-2.0.0-beta-6_darwin_arm64.tar.gz"
    sha256 "55bde100b7da2e4f0300d8a5043f06367d222f0882fbba70fded9dd73b0fcbf5"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-6/sibling-2.0.0-beta-6_linux_amd64.tar.gz"
    sha256 "51d2233d86f9e6ba24708d7f8168d708c6c205804cff8c5264d9a27e3f0098b5"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/sibling/releases/download/v2.0.0-beta-6/sibling-2.0.0-beta-6_linux_arm64.tar.gz"
    sha256 "ff5fa66402a039eec77684f4578245eee1d9f350aec2ee42aba1c82b410d74e4"
  end


  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end

  test do
    system "#{bin}/sibling --version"
  end
end
