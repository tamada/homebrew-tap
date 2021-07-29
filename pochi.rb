POCHI_VERSION = "2.4.6"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{POCHI_VERSION}/pochi-#{POCHI_VERSION}.zip"
  sha256 "0b5556952c3f76f60bbae18171781fecca31198ab948d08889a60505f97c6981"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    prefix.install "docs"
    prefix.install "data"
    prefix.install "examples"
    prefix.install "lib"
    prefix.install "LICENSE"
    prefix.install "README.md"
    bin.install "bin/pochi"

    bash_completion.install "completions/bash/pochi" if build.with? "completions"
  end

  def caveats
    <<~EOS
      The examples are available in the #{prefix}/examples
    EOS
  end
end
