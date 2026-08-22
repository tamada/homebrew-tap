VERSION="0.0.5"

class Fauxrest < Formula
  desc "Pseudo-REST static API generator"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/fauxrest"
  version VERSION
  license "MIT"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.5/fauxrest-0.0.5_amd64_darwin.tar.gz"
    sha256 "cd8c31540c06b1beb3c77989a3e0afed61580a69cc0214b13d9b013975d9aecf"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.5/fauxrest-0.0.5_amd64_linux.tar.gz"
    sha256 "5e709b642524e3085d214897457d26cc047c79e1bffaecedc9177eb792b2a8d3"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.5/fauxrest-0.0.5_arm64_darwin.tar.gz"
    sha256 "b0bd2ebf2d15ab0b34afc9c3044ef078e6633bf3682dcf5691db75691405ea55"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/fauxrest/releases/download/v0.0.5/fauxrest-0.0.5_arm64_linux.tar.gz"
    sha256 "41fd7b5f23ab7972abe25de028791c056f3e37cb19846d4e25737e64e04a7a56"
  end

  def install
    bin.install "fauxrest"

    bash_completion.install "completions/bash/fauxrest" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_fauxrest" if build.with? "completions"
    fish_completion.install "completions/fish/fauxrest.fish" if build.with? "completions"
  end

  test do
    system "#{bin}/fauxrest --version"
  end
end
