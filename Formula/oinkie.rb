VERSION="0.2.1"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.2.1/oinkie-0.2.1_amd64_darwin.tar.gz"
    sha256 "bc3380b138875241d891642a32c51ddd92d322322cb78893438431f55f81750f"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.2.1/oinkie-0.2.1_amd64_linux.tar.gz"
    sha256 "a3b7c0f8b2a447ad7fe77f9af56cfb80d5da6179e33f127fcfde380d518fb923"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.2.1/oinkie-0.2.1_arm64_darwin.tar.gz"
    sha256 "678c27dbf2c63b88625db8c1dd734255d214d5dfdbbe942aea78308e1ee9d814"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.2.1/oinkie-0.2.1_arm64_linux.tar.gz"
    sha256 "c791a4e14c93f6d293f6715176a2677cff27aac20a93493eab8e98eded1bcc46"
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
