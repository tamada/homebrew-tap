VERSION="0.3.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.3.0/oinkie-0.3.0_amd64_darwin.tar.gz"
    sha256 "c57a3f50b3d88b85c5fcba5a1563aaf40da99ea0033736fbeaa15833127a31be"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.3.0/oinkie-0.3.0_amd64_linux.tar.gz"
    sha256 "e01086dde8b2bbf839f849e31f7ffeb8976a15252719ada05f7593121c6d2a9c"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.3.0/oinkie-0.3.0_arm64_darwin.tar.gz"
    sha256 "a51282577196def7c97b8bbd997de631a6dced0a7317cdc9564e83f305a5b2b6"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.3.0/oinkie-0.3.0_arm64_linux.tar.gz"
    sha256 "8a8d8c8fcd3494db37b89d4b9326be8830dcf3f2d3e5d5da2e6622faa5acd175"
  end

  def install
    bin.install "oinkie"

    bash_completion.install "completions/bash/oinkie" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_oinkie" if build.with? "completions"
    fish_completion.install "completions/fish/oinkie" if build.with? "completions"
  end

  test do
    system "#{bin}/oinkie --version"
  end
end
