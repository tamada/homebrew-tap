VERSION="0.1.1"

class Spellout < Formula
  desc "A phonetic code encoder/decoder written in Rust"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/spellout"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/spellout/releases/download/v0.1.1/spellout-0.1.1_darwin_amd64.tar.gz"
    sha256 "a72282bc32f71577d25b00c94fad0953fa86a48103aefdab51498368da04ff9f"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/spellout/releases/download/v0.1.1/spellout-0.1.1_darwin_arm64.tar.gz"
    sha256 "bc638ba22934eba67dbb50765c5422bc79c36d848b7edf65dbd879979d0b1f87"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/spellout/releases/download/v0.1.1/spellout-0.1.1_linux_amd64.tar.gz"
    sha256 "b76d7f27a9a764ecdc6ad4c72b384c831c6718346a6f46b285515891d3aa7028"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/spellout/releases/download/v0.1.1/spellout-0.1.1_linux_arm64.tar.gz"
    sha256 "be1c44de5af518b0e5d95bb51663a92ea3a37dc069d70343e233f6366722b0c9"
  end

  def install
    bin.install "spellout"

    bash_completion.install "completions/bash/spellout" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_spellout" if build.with? "completions"
    fish_completion.install "completions/fish/spellout" if build.with? "completions"
  end

  test do
    system "#{bin}/spellout --version"
  end
end
