VERSION="0.5.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.5.0/oinkie-0.5.0_amd64_darwin.tar.gz"
    sha256 "b237d84289c7cd7dd640e7ccc2e32edd9a4389662957cfe8fde14dbfb6ebcae7"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.5.0/oinkie-0.5.0_amd64_linux.tar.gz"
    sha256 "63fe0779dcdb5a3ebcf675d7111be3b0af786a1459c698222cab9f9370206c7d"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.5.0/oinkie-0.5.0_arm64_darwin.tar.gz"
    sha256 "f9b6e715de4e765f48d5e49ae671aab5e05e52a4c90e65b8b04f43ac46caf595"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.5.0/oinkie-0.5.0_arm64_linux.tar.gz"
    sha256 "2980a2b0aa3e4cfaa9bf6c76ec6eef5c489f888961dc1f63acfcfbf3fdf3061a"
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
