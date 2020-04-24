require "formula"

POCHI_VERSION = "1.0.0"

class Pochi < Formula
  desc "Java birthmark toolkit, detecting the software theft by native characteristics of the programs."
  homepage "https://tamada.github.io/pochi"
  url "https://github.com/tamada/pochi/releases/download/v#{POCHI_VERSION}/pochi-#{POCHI_VERSION}-dist.zip"
  sha256 "0e47b350ee816826bd523cb5d5c2ae41ae792b834e213c34945e4c92c6c76d20"

  def install
      (bin/"pochi").write <<~EOS
        #! /bin/sh
        exec #{libexec}/bin/pochi.sh "$@"
      EOS
      libexec.install "lib"
      libexec.install "bin"
  end
end
