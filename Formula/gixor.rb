VERSION="0.2.8"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "Unlicensed license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.2.8/gixor-0.2.8_darwin_amd64.tar.gz"
    sha256 "10b0e80e24df9a7eb21c59aeae436f9d250402e53576641437861b6349b09a08"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.2.8/gixor-0.2.8_darwin_arm64.tar.gz"
    sha256 "2779ebe9dbcef8cf53c530c1c390d67bca77de6c7503ee3e040f17764a725b25"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.2.8/gixor-0.2.8_linux_arm64.tar.gz"
    sha256 "cf34ab13122a24adb03f79473860169d6e18da9442cfa862e2ea899f9da72c06"
  end

  def install
    bin.install "gixor"
    bin.install "gixor" => "git-ignore"

    bash_completion.install "completions/bash/gibo" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_gibo" if build.with? "completions"
    fish_completion.install "completions/fish/gibo" if build.with? "completions"
  end

  test do
    system "#{bin}/gixor --version"
  end
end
