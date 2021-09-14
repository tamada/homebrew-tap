POCHI_VERSION = "2.5.1"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{POCHI_VERSION}/pochi-#{POCHI_VERSION}.zip"
  sha256 "8da357c185458e31bab8d624fe89584bf4b0f9bb4039a1097b4d4190b6cc9b20"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    prefix.install "data"
    prefix.install "docs"
    prefix.install "dockers"
    prefix.install "examples"
    prefix.install "lib"
    prefix.install "LICENSE"
    prefix.install "README.md"

    bin.install "bin/pochi"

    bash_completion.install "completions/bash/pochi" if build.with? "completions"
    zsh_completion.install "completions/zsh/pochi" if build.with? "completions"
  end

  def caveats
    <<~EOS
      The examples are available in the #{prefix}/examples
    EOS
  end
end
