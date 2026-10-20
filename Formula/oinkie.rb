VERSION="0.8.1"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.1/oinkie-0.8.1_amd64_darwin.tar.gz"
    sha256 "b4bbe9b1fe75360b8783d3f704335524ef8836ff7fc492b757e718124aa086b2"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.1/oinkie-0.8.1_amd64_linux.tar.gz"
    sha256 "154a6c50bf141fbdb823299b403b71f19eb13fa11a1ec5d70380dcf9f4963f4b"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.1/oinkie-0.8.1_arm64_darwin.tar.gz"
    sha256 "adadf809abf613de1836224bcb1f694f78531175951bfbd383dc5f046c37a41b"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.8.1/oinkie-0.8.1_arm64_linux.tar.gz"
    sha256 "d893e31e90931781c8d3159c1372e1ada81acb1a7e857c7f279b3f8384c9e571"
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
