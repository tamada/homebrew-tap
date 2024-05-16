VERSION="0.8.1"

class GiboWrapper < Formula
  desc "gibo-wrapper acts like gibo to improve gibo by adding the following features"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional
  depends_on "gibo"

  homepage "https://github.com/tamada/gibo-wrapper"
  version VERSION
  license "Unlicensed license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.8.1/gibo-wrapper-0.8.1_darwin_amd64.tar.gz"
    sha256 "cc7a661b25ad9eaea1dcecc6820fabaa8afb02bc14101e00d9e0f309bc3b8359"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.8.1/gibo-wrapper-0.8.1_darwin_arm64.tar.gz"
    sha256 "7c6c70f18fd29d8a83fc8308b7ff32be25f4bec098538325c5722641433e5bb6"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.8.1/gibo-wrapper-0.8.1_linux_amd64.tar.gz"
    sha256 "32b822ff8cf4e634583fcb9642b9604865de42c43b642ae8bc3e7d026f87f0c5"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.8.1/gibo-wrapper-0.8.1_linux_arm64.tar.gz"
    sha256 "8bc1d837c7a4be7d39f018b1a496a300eba12180b15a0c3fb174d5c8cac304a8"
  end

  def install
    bin.install "gibo-wrapper"

    bash_completion.install "completions/bash/gibo" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_gibo" if build.with? "completions"
    fish_completion.install "completions/fish/gibo" if build.with? "completions"
  end

  test do
    system "#{bin}/gibo-wrapper --version"
  end

  def caveats
    <<~EOS
      Put the following alias setting into your shell configuration file.
          alias gibo='gibo-wrapper $@'
    EOS
  end
end
