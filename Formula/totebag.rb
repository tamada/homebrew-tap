VERSION="0.8.11"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.11/totebag-0.8.11_darwin_amd64.tar.gz"
    sha256 "5f3e31ec9611cb80670aad265f63de4206f4e663da16ec990c8c62e2aa300b0b"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.11/totebag-0.8.11_darwin_arm64.tar.gz"
    sha256 "4acb6461833c7107a4facb14f11d8123e5b268c01b502e6cbe5ad66ba9c2c3bc"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.11/totebag-0.8.11_linux_amd64.tar.gz"
    sha256 "9b10b5534f72f0447fc31d206f511cd5e7492893fb7d3893a211a71f8d65848e"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.11/totebag-0.8.11_linux_arm64.tar.gz"
    sha256 "d5ce3c21167fb88419dd2db4c5d04e3a4e5218e3badf4ceb6f57aaa4be66325d"
  end

  def install
    bin.install "totebag"

    bash_completion.install "assets/completions/bash/totebag" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_totebag" if build.with? "completions"
    fish_completion.install "assets/completions/fish/totebag" if build.with? "completions"
  end

  test do
    system "#{bin}/totebag --version"
  end
end
