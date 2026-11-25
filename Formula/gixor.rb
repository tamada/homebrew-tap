VERSION="0.6.0"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.6.0/gixor-0.6.0_darwin_amd64.tar.gz"
    sha256 "dbc467ea44acc8c01f578b413d700644b9c5f10877f3e5a36b13a941413ecc6f"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.6.0/gixor-0.6.0_darwin_arm64.tar.gz"
    sha256 "e253b24a8c3ac4ba3f32ddb0ecde112f1f4fe3a3a9e6286d0e787a1cda7eaab0"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.6.0/gixor-0.6.0_linux_amd64.tar.gz"
    sha256 "7f2691e6c2fe433b0c2a3b96a3ed81c2d27a412e0a5c812a4516fae386b45635"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.6.0/gixor-0.6.0_linux_arm64.tar.gz"
    sha256 "9730e4674f7537fb50f34d44d26ae5d63e57e8544c94c9b4d05064d9fa784ad0"
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
