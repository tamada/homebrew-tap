VERSION="2.6.0"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{VERSION}/pochi-#{VERSION}.zip"
  sha256 "b9e322613e27403b1052cae2c988aad353aae7a5b411e3cc9890a0fa37d52c5a"

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
