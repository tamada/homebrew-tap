VERSION="0.3.4"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.3.4/gixor-0.3.4_darwin_amd64.tar.gz"
    sha256 "24e86987ea4282228ee61e29e86cef0841a61888d07a8bbe4e3c9cb75548bc1a"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.3.4/gixor-0.3.4_darwin_arm64.tar.gz"
    sha256 "91be87b9a322af64b862799e973a1d75444524164afe9676cd286291c2b145f2"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.3.4/gixor-0.3.4_linux_amd64.tar.gz"
    sha256 "2673c7f68ba6cc9eb2b59a9dd4aa0739fda69445af23b591d030ea326a515a73"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.3.4/gixor-0.3.4_linux_arm64.tar.gz"
    sha256 "f44acff3713c95eebcea171431ddceb8490996160e059900ca1c555bba20759a"
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
