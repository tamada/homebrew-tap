VERSION="0.4.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.4.0/oinkie-0.4.0_amd64_darwin.tar.gz"
    sha256 "8eaa9443991801506752e8d0ca056df491d45304eda4e5898cee107a9baaf61a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.4.0/oinkie-0.4.0_amd64_linux.tar.gz"
    sha256 "de89df2eb3f2b1b6a97db2c21000b0033a19a2d539c22f4634244b6f52d4e82a"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.4.0/oinkie-0.4.0_arm64_darwin.tar.gz"
    sha256 "6cf1d326311cf8233888a320313422f40960d9876214cdd53eab37a4c6a9db2b"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.4.0/oinkie-0.4.0_arm64_linux.tar.gz"
    sha256 "ef9e21de03932fdc25f788d34254848ee0f1605520afc073f51c8f5475cb3f1f"
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
