VERSION="0.1.1"

class Heatman < Formula
  desc "Creating heat map from given csv file."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/heatman"
  version VERSION
  license "MIT License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/heatman/releases/download/v0.1.1/heatman-0.1.1_darwin_amd64.tar.gz"
    sha256 "d5d79d575b02c70acd7cccc67aefe51aabe40f277d5124b39f150939b330e190"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/heatman/releases/download/v0.1.1/heatman-0.1.1_darwin_arm64.tar.gz"
    sha256 "b4e33e9d4477ee66fc0b4aab8c685bf809cf0c66203b6381fc149659bd1add93"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/heatman/releases/download/v0.1.1/heatman-0.1.1_linux_amd64.tar.gz"
    sha256 "fee7d8728fcecc1bb1c9f99ccce526a54cf19ae00925059820f680f9b68f0d1b"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/heatman/releases/download/v0.1.1/heatman-0.1.1_linux_arm64.tar.gz"
    sha256 "8c735b54412640137ff2c356f8cb615aaf85758ff1c90c18c9a80ea28214d469"
  end

  def install
    bin.install "heatman"

    bash_completion.install "completions/bash/heatman" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_heatman" if build.with? "completions"
    fish_completion.install "completions/fish/heatman" if build.with? "completions"
  end

  test do
    system "#{bin}/heatman --version"
  end
end
