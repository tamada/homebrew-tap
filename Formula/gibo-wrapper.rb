VERSION="0.9.0"

class GiboWrapper < Formula
  desc "gibo-wrapper acts like gibo to improve gibo by adding the following features"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional
  depends_on "gibo"

  homepage "https://github.com/tamada/gibo-wrapper"
  version VERSION
  license "Unlicensed license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.9.0/gibo-wrapper-0.9.0_darwin_amd64.tar.gz"
    sha256 "e83a2cbd584ea20b61d87c55df4422a0b928ac02d6dc44feef2db1203b214961"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.9.0/gibo-wrapper-0.9.0_darwin_arm64.tar.gz"
    sha256 "f1eb84e82cd1cfbd7f42242724cc43370b5145347b11ebdb8ac300e69b65d5bf"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.9.0/gibo-wrapper-0.9.0_linux_amd64.tar.gz"
    sha256 "6d8c3b9963fbe3d51893496e0fe52a0b40267d187878bbed9dc2e1d99b99b2fc"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gibo-wrapper/releases/download/v0.9.0/gibo-wrapper-0.9.0_linux_arm64.tar.gz"
    sha256 "bfa181bc0b0a6bf5f601f43cc59d8ccd34df1dea5efab8ec471802073a6020e4"
  end

  def install
    bin.install "gibo-wrapper"

    bash_completion.install "completions/bash/gibo" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_gibo" if build.with? "completions"
    fish_completion.install "completions/fish/gibo" if build.with? "completions"
  end

  deprecate! date: "2025-05-15", replacement_formula: "gixor", because: :repo_archived

  test do
    system "#{bin}/gibo-wrapper --version"
  end

  def caveats
    <<~EOS
      Put the following alias setting into your shell configuration file.
          alias gibo='gibo-wrapper $@'
    EOS
  end
end
