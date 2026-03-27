VERSION="0.1.0"

class Heatman < Formula
  desc "Creating heat map from given csv file."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/heatman"
  version VERSION
  license "MIT License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/heatman/releases/download/v0.1.0/heatman-0.1.0_darwin_amd64.tar.gz"
    sha256 "3907279f0e7a78f90b33429bb1fc35762118e6f88c410308dee502f8dd8c2457"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/heatman/releases/download/v0.1.0/heatman-0.1.0_darwin_arm64.tar.gz"
    sha256 "3f04be1c33b1334fa30c131e7828339d70dad7a52c9ed1c4e520e1e9072ae1a8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/heatman/releases/download/v0.1.0/heatman-0.1.0_linux_amd64.tar.gz"
    sha256 "6b1332775699ca7f25690aca715b2dc0a593a17d03900b7ed102b79921225285"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/heatman/releases/download/v0.1.0/heatman-0.1.0_linux_arm64.tar.gz"
    sha256 "337dc9af69ed4b48e101f55e7cf822fba678fcc92a31d14fac68e3dfbbbc39fc"
  end

  def install
    bin.install "heatman"

    bash_completion.install "assets/completions/bash/heatman" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_heatman" if build.with? "completions"
    fish_completion.install "assets/completions/fish/heatman" if build.with? "completions"
  end

  test do
    system "#{bin}/heatman --version"
  end
end
