VERSION="0.4.1"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.4.1/gixor-0.4.1_darwin_amd64.tar.gz"
    sha256 "4f24ccbe8569d2259de986d62c74cb08432fa1f41e16d8db683cd101862acbbe"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.4.1/gixor-0.4.1_darwin_arm64.tar.gz"
    sha256 "e3e7d56eea9a9b64ddca1c788baa933a6e9907b3fe7447fa3f1afb5d42e4ee0b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.4.1/gixor-0.4.1_linux_amd64.tar.gz"
    sha256 "fe76c45431628f9e582b052e1ac3f53d61ba143b71b5878d4b3f4d8431141d7a"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.4.1/gixor-0.4.1_linux_arm64.tar.gz"
    sha256 "dfd577416ccf4a66637fde554b7c54021e8f94f22b8333d4c00b8937207cdee6"
  end

  def install
    bin.install "gixor"
    system "ln -s \"#{bin}/gixor\" #{bin}/git-ignore"

    bash_completion.install "assets/completions/bash/gixor" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_gixor" if build.with? "completions"
    fish_completion.install "assets/completions/fish/gixor" if build.with? "completions"
  end

  test do
    system "#{bin}/gixor --version"
  end
end
