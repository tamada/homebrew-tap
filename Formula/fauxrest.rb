VERSION="0.0.2"

class Oinkie < Formula
  desc "Pseudo-REST static API generator"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/fauxrest"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.2/fauxrest-0.0.2_amd64_darwin.tar.gz"
    sha256 "2971389e38319f1f30329684ba07acc0542adae5be3d915d39dc91ef27070a35"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.2/fauxrest-0.0.2_amd64_linux.tar.gz"
    sha256 "14f6036a769c9f2c476c77410b0b6babbf5bdd8840f8df8059383cb84c6b6a72"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.2/fauxrest-0.0.2_arm64_darwin.tar.gz"
    sha256 "6da235d43ca6dab73cc4067d3778526e081760137ea787341b1b8e67010bff89"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.2/fauxrest-0.0.2_arm64_linux.tar.gz"
    sha256 "08a1e68e94d78b41147e5ccb63aef0d94ae89a4c702c20ac5f96a760af804877"
  end

  def install
    bin.install "fauxrest"

    bash_completion.install "completions/bash/fauxrest" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_fauxrest" if build.with? "completions"
    fish_completion.install "completions/fish/fauxrest" if build.with? "completions"
  end

  test do
    system "#{bin}/fauxrest --version"
  end
end
