VERSION="0.7.0"

class Oinkie < Formula
  desc "The software birthmark toolkit for real-world executables"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/oinkie"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.7.0/oinkie-0.7.0_amd64_darwin.tar.gz"
    sha256 "93f4bbf40c2e4a52b0f70362c3bf2057e7ccecb691f8217efb5ce6944e0c1f6d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/oinkie/releases/download/v0.7.0/oinkie-0.7.0_amd64_linux.tar.gz"
    sha256 "c63d4d2cc16739e8425d0664856d186bacff3acb6a552763850492b8c5b31236"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.7.0/oinkie-0.7.0_arm64_darwin.tar.gz"
    sha256 "763f647913867c6d2c58022e2b6f92fdcce404e56141f6abf730f3ecde01a247"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/oinkie/releases/download/v0.7.0/oinkie-0.7.0_arm64_linux.tar.gz"
    sha256 "5d03077cb1c502fc8901162d970ce5ec44b7d5dbcb176b28e2a6f4967ad3a478"
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
