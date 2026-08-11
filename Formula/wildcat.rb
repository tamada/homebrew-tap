VERSION="v1.2.0"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  version VERSION
  license "Apache-2.0 License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_darwin_amd64.tar.gz"
    sha256 "308046086a8531f162b3096002951adb629c55a6c99e7d335f7f60732ff93a67"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_darwin_arm64.tar.gz"
    sha256 "72a106fcd128b289585b84e9e1a63b960d334176608b6dc33a450195528a1e7c"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_linux_386.tar.gz"
    sha256 "17d57fdcbc80fbf01abc23df420de0395dcd15f17f7996f765c22bcfd4745772"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_linux_amd64.tar.gz"
    sha256 "232d89f0166b23bfcb588502c3b1a897f8691e91ab6c67d31b4cfeb57521d1bc"
  end
  if OS.windows? && Hardware::CPU.intel?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_windows_386.tar.gz"
    sha256 "bdbdbce3167f8f6663a2ff79a41c8559e638592cf00cda1d895298a13e3f47e0"
  end
  if OS.windows? && Hardware::CPU.intel?
    url "https://github.com/tamada/wildcat/releases/download/v1.2.0/wildcat-1.2.0_windows_amd64.tar.gz"
    sha256 "f083b5e5a9d3fb666cb3525574e1a08bba8a6f696dc8853771a9862d7333430c"
  end

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "wildcat"

    prefix.install_metafiles
    prefix.install "docs"

    bash_completion.install "completions/bash/wildcat.bash" if build.with? "completions"
  end

  test do
      system bin/"wildcat", "--version"
  end
end
