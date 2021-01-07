require "formula"

POCHI_VERSION = "2.2.0"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{POCHI_VERSION}/pochi-#{POCHI_VERSION}.zip"
  sha256 "b38a5c33d2df33c8b31777e5e2175aa9a3a056dd780c2f90e3ae139c44a24267"

  def install
    prefix.install "completions"
    prefix.install "Dockerfile"
    prefix.install "docs"
    prefix.install "examples"
    prefix.install "lib"
    prefix.install "LICENSE"
    prefix.install "README.md"
    bin.install "bin/pochi"

    if build.with? "completions"
      bash_completion.install "completions/bash/pochi.bash"
    end
  end

  def caveats
    <<~EOS
      The examples are available in the #{prefix}/examples
    EOS
  end
end
