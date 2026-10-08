VERSION="0.8.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.0/oinkie-0.8.0_amd64_darwin.tar.gz"
    sha256 "a8a1ed7a887ff1a1b6431faa0c5b77d5fca35674562e0ea185840886474dc61a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.0/oinkie-0.8.0_amd64_linux.tar.gz"
    sha256 "4d8c466dfe9f64ae49955a3a6422aca86b7e48f416362c047ed0ece2c26b64d9"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.0/oinkie-0.8.0_arm64_darwin.tar.gz"
    sha256 "56e13ea3031fad163890f053ed6cb0bf999755a5bd90cf0964113ba710844c8e"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.0/oinkie-0.8.0_arm64_linux.tar.gz"
    sha256 "d0d912a7163a38846a3c90f348ae4cd98019ff760d0b9d305f0daa0d675b7442"
  end

  def install
    bin.install "oinkie"

    bash_completion.install "completions/bash/oinkie" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_oinkie" if build.with? "completions"
    fish_completion.install "completions/fish/oinkie.fish" if build.with? "completions"
  end

  test do
    system "#{bin}/oinkie --version"
  end
end
